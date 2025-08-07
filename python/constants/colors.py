"""
PathWise Color Palette
Custom color scheme for terminal output
"""

# Original hex palette provided
HEX_PALETTE = {
    'cream_light': '#fff8c2',
    'cream': '#eff3ff',
    'beige_light': '#e8e8df',
    'beige': '#dbdbd0',
    'brown_light': '#ccab78',
    'brown': '#b27f52',
    'brown_dark': '#ab6c2c',
    'orange_bright': '#f88046',
    'gold': '#ffcc67',
    'gold_dark': '#a67c23',
    'amber': '#996d20',
    'rust': '#995325',
    'rust_dark': '#8f422c',
    'pink': '#d964ab',
    'pink_dark': '#b1317f',
    'pink_darker': '#c54091',
    'pink_light': '#f6b0db',
    'green_dark': '#364f33',
    'green_olive': '#374529',
    'green_sage': '#466b5d',
    'teal': '#587a84',
    'teal_dark': '#344a4d',
    'blue_dark': '#003190',
    'blue': '#4f8eff',
    'blue_gray': '#375c69',
    'gray': '#6f6d76',
    'gray_medium': '#5e5d5d',
    'gray_dark': '#3e3c42',
    'gray_darker': '#29323b',
    'gray_navy': '#304452',
    'brown_gray': '#8f897b',
    'brown_rust': '#9e6a55',
    'brown_tan': '#be9167',
    'brown_deep': '#5e431f',
    'brown_darkest': '#403125',
    'red_wine': '#930235',
    'red_muted': '#9c525a',
    'red_brown': '#866068',
    'cyan': '#418791',
    'sand': '#b3b09f',
    'charcoal': '#292225',
    'black': '#000000',
    'white': '#ffffff'
}

# ANSI color codes (standard 16 colors + 256 color mode)
# Using 256-color mode for better color matching
class ANSIColor:
    """ANSI escape sequences for colors"""
    
    # Reset
    RESET = '\033[0m'
    
    # Text styles
    BOLD = '\033[1m'
    DIM = '\033[2m'
    ITALIC = '\033[3m'
    UNDERLINE = '\033[4m'
    
    # Standard colors (30-37 for foreground, 90-97 for bright)
    BLACK = '\033[30m'
    RED = '\033[31m'
    GREEN = '\033[32m'
    YELLOW = '\033[33m'
    BLUE = '\033[34m'
    MAGENTA = '\033[35m'
    CYAN = '\033[36m'
    WHITE = '\033[37m'
    
    # Bright colors
    BRIGHT_BLACK = '\033[90m'
    BRIGHT_RED = '\033[91m'
    BRIGHT_GREEN = '\033[92m'
    BRIGHT_YELLOW = '\033[93m'
    BRIGHT_BLUE = '\033[94m'
    BRIGHT_MAGENTA = '\033[95m'
    BRIGHT_CYAN = '\033[96m'
    BRIGHT_WHITE = '\033[97m'
    
    # 256 color mode (more accurate color matching)
    @staticmethod
    def color256(code):
        """Generate 256-color ANSI code"""
        return f'\033[38;5;{code}m'
    
    @staticmethod
    def bg256(code):
        """Generate 256-color background ANSI code"""
        return f'\033[48;5;{code}m'

# Map our palette to closest 256-color codes
COLOR_256_MAP = {
    'cream': 230,        # Cream white
    'gold': 220,         # Gold yellow  
    'orange': 208,       # Orange
    'pink': 169,         # Pink
    'green': 65,         # Sage green
    'teal': 73,          # Teal
    'blue': 69,          # Blue
    'red': 167,          # Muted red
    'brown': 137,        # Brown
    'gray': 244,         # Medium gray
    'gray_dark': 238,    # Dark gray
    'success': 71,       # Success green
    'warning': 214,      # Warning orange
    'error': 160,        # Error red
    'info': 75,          # Info blue
}

# PathWise semantic color mapping
class PathWiseColors:
    """Semantic color assignments for PathWise UI elements"""
    
    # Core UI elements
    HEADER = ANSIColor.color256(COLOR_256_MAP['green'])
    SUBHEADER = ANSIColor.color256(COLOR_256_MAP['teal'])
    
    # Jump shortcuts [j1], [j2], etc.
    JUMP_BRACKET = ANSIColor.CYAN
    
    # Directory paths
    DIR_PATH = ANSIColor.RESET
    
    # Visit counts and time by duration
    TIME_LOW = ANSIColor.YELLOW           # < 10 min (default yellow)
    TIME_MEDIUM = ANSIColor.BRIGHT_YELLOW  # < 30 min
    TIME_HIGH = ANSIColor.BRIGHT_RED      # < 1 hour  
    TIME_VERY_HIGH = ANSIColor.RED        # > 1 hour
    
    # Git commits
    GIT_COMMITS = ANSIColor.BRIGHT_YELLOW
    
    # Yesterday's data
    YESTERDAY = ANSIColor.BRIGHT_BLACK
    
    # Status messages
    SUCCESS = ANSIColor.GREEN
    WARNING = ANSIColor.color256(COLOR_256_MAP['warning'])
    ERROR = ANSIColor.color256(COLOR_256_MAP['error'])
    INFO = ANSIColor.color256(COLOR_256_MAP['info'])
    
    # Configuration
    CONFIG_LABEL = ANSIColor.color256(COLOR_256_MAP['gray'])
    CONFIG_VALUE = ANSIColor.WHITE
    
    # Insights
    INSIGHT_TITLE = ANSIColor.color256(COLOR_256_MAP['blue'])
    INSIGHT_DATA = ANSIColor.RESET
    INSIGHT_PERCENT = ANSIColor.color256(COLOR_256_MAP['gold'])
    
    # Emojis stay as is but text gets colors
    EMOJI_TEXT = ANSIColor.RESET
    
    # Prompts
    PROMPT = ANSIColor.color256(COLOR_256_MAP['teal'])
    
    # Reset
    RESET = ANSIColor.RESET

# Export color codes for shell script
def get_shell_colors():
    """Generate shell variable declarations for colors"""
    colors = []
    
    # Basic ANSI colors
    colors.append(f"COLOR_RESET='{ANSIColor.RESET}'")
    colors.append(f"COLOR_BOLD='{ANSIColor.BOLD}'")
    
    # PathWise semantic colors
    colors.append(f"COLOR_HEADER='{PathWiseColors.HEADER}'")
    colors.append(f"COLOR_JUMP='{PathWiseColors.JUMP_BRACKET}'")
    colors.append(f"COLOR_TIME_LOW='{PathWiseColors.TIME_LOW}'")
    colors.append(f"COLOR_TIME_MEDIUM='{PathWiseColors.TIME_MEDIUM}'")
    colors.append(f"COLOR_TIME_HIGH='{PathWiseColors.TIME_HIGH}'")
    colors.append(f"COLOR_TIME_VERY_HIGH='{PathWiseColors.TIME_VERY_HIGH}'")
    colors.append(f"COLOR_GIT='{PathWiseColors.GIT_COMMITS}'")
    colors.append(f"COLOR_YESTERDAY='{PathWiseColors.YESTERDAY}'")
    colors.append(f"COLOR_SUCCESS='{PathWiseColors.SUCCESS}'")
    colors.append(f"COLOR_WARNING='{PathWiseColors.WARNING}'")
    colors.append(f"COLOR_ERROR='{PathWiseColors.ERROR}'")
    colors.append(f"COLOR_INFO='{PathWiseColors.INFO}'")
    
    return '\n'.join(colors)

if __name__ == '__main__':
    # Test color output
    print(f"{PathWiseColors.HEADER}PathWise Color Test{PathWiseColors.RESET}")
    print(f"{PathWiseColors.JUMP_BRACKET}[j1]{PathWiseColors.RESET} ~/projects/pathwise")
    print(f"{PathWiseColors.TIME_VERY_HIGH}(5 visits · 2h 34m today){PathWiseColors.RESET}")
    print(f"{PathWiseColors.GIT_COMMITS}[12 commits]{PathWiseColors.RESET}")
    print(f"{PathWiseColors.SUCCESS}✅ Success message{PathWiseColors.RESET}")
    print(f"{PathWiseColors.WARNING}⚠️  Warning message{PathWiseColors.RESET}")
    print(f"{PathWiseColors.ERROR}❌ Error message{PathWiseColors.RESET}")