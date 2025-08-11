"""
Project Root Detection Logic
Intelligently identifies project root directories to consolidate navigation
"""

import os
import glob
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import json
import time
from functools import lru_cache

from python.constants.project_indicators import (
    STRONG_INDICATORS,
    MEDIUM_INDICATORS,
    STOP_DIRS,
    BLACKLIST_DIRS,
    CHECK_PARENT_PATTERNS,
    should_stop_traversal,
    is_blacklisted,
    suggests_parent_check,
)

# Cache file for project roots (JSON format)
CACHE_FILE = os.path.expanduser("~/.frequent_dirs.project_cache")
CACHE_TTL = 3600  # 1 hour in seconds

# In-memory cache for this session
_memory_cache: Dict[str, Tuple[str, str, float]] = {}


def load_cache() -> Dict[str, Tuple[str, str, float]]:
    """Load project cache from disk

    Returns:
        Dict mapping directory -> (project_root, project_type, timestamp)
    """
    if not os.path.exists(CACHE_FILE):
        return {}

    try:
        with open(CACHE_FILE, "r") as f:
            cache_data = json.load(f)
            # Convert lists back to tuples
            return {k: tuple(v) for k, v in cache_data.items()}
    except (json.JSONDecodeError, IOError):
        return {}


def save_cache(cache: Dict[str, Tuple[str, str, float]]) -> None:
    """Save project cache to disk"""
    try:
        # Convert tuples to lists for JSON serialization
        cache_data = {k: list(v) for k, v in cache.items()}
        with open(CACHE_FILE, "w") as f:
            json.dump(cache_data, f)
    except IOError:
        pass  # Fail silently if we can't write cache


def check_indicators(
    directory: str, indicators: Dict[str, str]
) -> Optional[Tuple[str, str]]:
    """Check if directory contains any project indicators

    Args:
        directory: Path to check
        indicators: Dictionary of indicator -> project_type

    Returns:
        Tuple of (indicator_found, project_type) or None
    """
    if not os.path.exists(directory) or not os.path.isdir(directory):
        return None

    try:
        dir_contents = os.listdir(directory)
    except (PermissionError, OSError):
        return None

    for indicator, project_type in indicators.items():
        # Handle glob patterns (like *.sln)
        if "*" in indicator:
            matches = glob.glob(os.path.join(directory, indicator))
            if matches:
                return (os.path.basename(matches[0]), project_type)
        # Direct file/directory check
        elif indicator in dir_contents:
            return (indicator, project_type)

    return None


def find_project_root(
    directory: str, max_depth: int = 10, use_cache: bool = True
) -> Tuple[str, str, List[str]]:
    """Find the project root for a given directory

    Args:
        directory: Directory to find project root for
        max_depth: Maximum levels to traverse up
        use_cache: Whether to use caching

    Returns:
        Tuple of (project_root, project_type, subdirs_in_project)
    """
    # Normalize the directory path
    directory = os.path.expanduser(directory)
    directory = os.path.abspath(directory)

    # Check memory cache first
    if use_cache and directory in _memory_cache:
        root, proj_type, timestamp = _memory_cache[directory]
        if time.time() - timestamp < CACHE_TTL:
            return (root, proj_type, [directory] if directory != root else [])

    # Check disk cache
    if use_cache:
        cache = load_cache()
        if directory in cache:
            root, proj_type, timestamp = cache[directory]
            if time.time() - timestamp < CACHE_TTL:
                _memory_cache[directory] = (root, proj_type, timestamp)
                return (
                    root,
                    proj_type,
                    [directory] if directory != root else [],
                )

    # Check if this directory is blacklisted
    dir_name = os.path.basename(directory)
    if is_blacklisted(dir_name):
        # For blacklisted dirs, always look for parent project
        parent = os.path.dirname(directory)
        if parent != directory:  # Not at root
            parent_root, parent_type, _ = find_project_root(
                parent, max_depth - 1, use_cache
            )
            return (parent_root, parent_type, [directory])

    # Perform actual detection
    original_dir = directory
    subdirs = []
    current = directory
    depth = 0

    # First pass: Check for strong indicators
    while depth < max_depth:
        # Check if we should stop traversal
        if should_stop_traversal(current):
            break

        # Check for strong indicators
        result = check_indicators(current, STRONG_INDICATORS)
        if result:
            indicator, project_type = result
            # Found a strong indicator - this is the project root
            root = current
            
            # If it's a generic VCS type, check if there's a more specific language indicator
            if project_type in ["git", "svn", "mercurial", "bazaar", "fossil"]:
                # Check for language-specific indicators at the same level
                for lang_indicator, lang_type in STRONG_INDICATORS.items():
                    if lang_type not in ["git", "svn", "mercurial", "bazaar", "fossil"]:
                        if os.path.exists(os.path.join(current, lang_indicator)):
                            project_type = lang_type  # Override with language-specific type
                            break

            # Store in cache
            if use_cache:
                timestamp = time.time()
                _memory_cache[original_dir] = (root, project_type, timestamp)
                cache = load_cache()
                cache[original_dir] = (root, project_type, timestamp)
                save_cache(cache)

            return (root, project_type, subdirs)

        # Track subdirectories for aggregation
        if current != original_dir:
            subdirs.append(current)

        # Move up one directory
        parent = os.path.dirname(current)
        if parent == current:  # Reached root
            break

        current = parent
        depth += 1

    # Second pass: Check for medium indicators
    current = directory
    subdirs = []
    depth = 0

    while depth < max_depth:
        if should_stop_traversal(current):
            break

        # Check for medium indicators
        result = check_indicators(current, MEDIUM_INDICATORS)
        if result:
            indicator, project_type = result
            root = current

            # Store in cache
            if use_cache:
                timestamp = time.time()
                _memory_cache[original_dir] = (root, project_type, timestamp)
                cache = load_cache()
                cache[original_dir] = (root, project_type, timestamp)
                save_cache(cache)

            return (root, project_type, subdirs)

        if current != original_dir:
            subdirs.append(current)

        parent = os.path.dirname(current)
        if parent == current:
            break

        current = parent
        depth += 1

    # No project root found - directory stands alone
    # But check if directory name suggests it's part of a project
    dir_name = os.path.basename(original_dir)
    if suggests_parent_check(dir_name) and depth < max_depth:
        # Try one more level up
        parent = os.path.dirname(original_dir)
        if parent != original_dir:
            result = check_indicators(
                parent, STRONG_INDICATORS
            ) or check_indicators(parent, MEDIUM_INDICATORS)
            if result:
                _, project_type = result
                return (parent, project_type, [original_dir])

    # Return original directory as standalone
    project_type = "standalone"
    if use_cache:
        timestamp = time.time()
        _memory_cache[original_dir] = (original_dir, project_type, timestamp)
        cache = load_cache()
        cache[original_dir] = (original_dir, project_type, timestamp)
        save_cache(cache)

    return (original_dir, project_type, [])


def clear_cache() -> None:
    """Clear all project detection caches"""
    global _memory_cache
    _memory_cache = {}

    if os.path.exists(CACHE_FILE):
        try:
            os.remove(CACHE_FILE)
        except OSError:
            pass


def get_project_info_for_shell(directory: str) -> str:
    """Get project info formatted for shell consumption

    Args:
        directory: Directory to check

    Returns:
        String in format: "project_root|project_type|subdir_count"
    """
    root, project_type, subdirs = find_project_root(directory)
    subdir_count = len(subdirs)

    # Convert home directory to ~ for consistency
    home = os.path.expanduser("~")
    if root.startswith(home):
        root = "~" + root[len(home) :]

    return f"{root}|{project_type}|{subdir_count}"


# Command-line interface for shell integration
if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Usage: python project_detector.py <directory> [--clear-cache]")
        sys.exit(1)

    if sys.argv[1] == "--clear-cache":
        clear_cache()
        print("Cache cleared")
        sys.exit(0)

    directory = sys.argv[1]
    print(get_project_info_for_shell(directory))
