"""
Git Commit Tracking and Categorization Logic
Functions for intelligent commit categorization and keyword suggestions
"""

import random
from typing import Dict, List, Tuple

# Import constants
from python.constants.git_tracker import COMMIT_CATEGORIES, DEFAULT_CATEGORY, DEFAULT_EMOJI

def categorize_commit(commit_message: str) -> str:
    """
    Categorize a commit message using priority-based scoring.
    
    Args:
        commit_message: The commit message to categorize
        
    Returns:
        The category name with highest score, or 'other' if no match
    """
    msg_lower = commit_message.lower()
    category_scores = {}
    
    # Calculate scores for each category
    for category, info in COMMIT_CATEGORIES.items():
        keyword_count = 0
        for keyword in info['keywords']:
            # Count occurrences of each keyword
            if keyword in msg_lower:
                keyword_count += msg_lower.count(keyword)
        
        if keyword_count > 0:
            # Score = keyword_count * priority
            category_scores[category] = keyword_count * info['priority']
    
    # Return category with highest score
    if category_scores:
        return max(category_scores, key=category_scores.get)
    
    return DEFAULT_CATEGORY

def get_random_keyword_suggestions(num_suggestions: int = 3) -> List[Tuple[str, str, str]]:
    """
    Get random keyword suggestions from different categories.
    
    Args:
        num_suggestions: Number of suggestions to return
        
    Returns:
        List of tuples (category, emoji, keyword)
    """
    suggestions = []
    
    # Get random categories (excluding the ones already used)
    available_categories = list(COMMIT_CATEGORIES.keys())
    random.shuffle(available_categories)
    
    for i in range(min(num_suggestions, len(available_categories))):
        category = available_categories[i]
        info = COMMIT_CATEGORIES[category]
        
        # Get random keyword from this category
        keyword = random.choice(info['keywords'])
        
        suggestions.append((category, info['emoji'], keyword))
    
    return suggestions

def get_category_keywords_for_shell() -> Dict[str, str]:
    """
    Get category keywords formatted for shell script.
    
    Returns:
        Dictionary with category names as keys and space-separated keywords as values
    """
    result = {}
    for category, info in COMMIT_CATEGORIES.items():
        # Include ALL keywords for accurate categorization
        keywords = info['keywords']
        result[category] = ' '.join(keywords)
    
    return result

def get_categories_for_shell() -> str:
    """
    Generate shell variable declarations for categories and keywords.
    
    Returns:
        Shell script string with category definitions
    """
    lines = []
    
    for category, info in COMMIT_CATEGORIES.items():
        # Include ALL keywords for accurate categorization
        keywords = ' '.join(info['keywords'])
        var_name = f"{category}_keywords"
        lines.append(f'    local {var_name}="{keywords}"')
    
    return '\n'.join(lines)

def format_keyword_suggestion_shell(suggestions: List[Tuple[str, str, str]]) -> str:
    """
    Format keyword suggestions for shell output.
    
    Args:
        suggestions: List of (category, emoji, keyword) tuples
        
    Returns:
        Formatted shell echo command
    """
    if not suggestions:
        return ""
    
    # Build the suggestion text
    keywords = []
    for category, emoji, keyword in suggestions:
        keywords.append(f"{emoji} {keyword}")
    
    keywords_text = ", ".join(keywords)
    
    return f'echo "  💡 Tip: Use keywords like {keywords_text} in your commit messages"'

# Example usage and testing
if __name__ == "__main__":
    # Test commit categorization
    test_commits = [
        "fix: resolve issue with login",
        "add new feature for user dashboard",
        "update dependencies to latest version",
        "improve performance of database queries",
        "refactor authentication module",
        "docs: update README with new examples",
        "style: fix indentation in main.py",
        "test: add unit tests for payment service",
        "build: configure webpack for production",
        "ci: add github actions workflow",
        "revert previous commit that broke tests",
        "random commit message without keywords"
    ]
    
    print("Testing commit categorization:")
    print("-" * 50)
    for commit in test_commits:
        category = categorize_commit(commit)
        emoji = COMMIT_CATEGORIES.get(category, {}).get('emoji', DEFAULT_EMOJI)
        print(f"{emoji} {category:10} | {commit}")
    
    print("\n" + "=" * 50)
    print("Random keyword suggestions:")
    print("-" * 50)
    
    for _ in range(3):
        suggestions = get_random_keyword_suggestions(3)
        for cat, emoji, keyword in suggestions:
            print(f"  {emoji} {cat:10} | Use '{keyword}' for {cat} commits")
        print()