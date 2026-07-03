pragma Singleton
import QtQuick

QtObject {
    // Current theme state
    property bool isDark: appModel.isDarkTheme
    
    // Light theme colors
    property color lightBackground: "#FFFFFF"
    property color lightSidebarBackground: "#F5F5F5"
    property color lightTextColor: "#333333"
    property color lightBorderColor: "#E0E0E0"
    property color lightHighlight: "#E8F4FD"
    
    // Dark theme colors
    property color darkBackground: "#1E1E1E"
    property color darkSidebarBackground: "#2D2D2D"
    property color darkTextColor: "#E0E0E0"
    property color darkBorderColor: "#404040"
    property color darkHighlight: "#2A4F6F"
    
    // Dynamic colors
    property color backgroundColor: isDark ? darkBackground : lightBackground
    property color sidebarBackgroundColor: isDark ? darkSidebarBackground : lightSidebarBackground
    property color textColor: isDark ? darkTextColor : lightTextColor
    property color borderColor: isDark ? darkBorderColor : lightBorderColor
    property color highlightColor: isDark ? darkHighlight : lightHighlight
    
    // Common colors
    property color primaryColor: "#1E90FF"
    property color successColor: "#4CAF50"
    property color errorColor: "#F44336"
    property color warningColor: "#FF9800"
    
    // Font sizes
    property int fontSizeLarge: 16
    property int fontSizeMedium: 14
    property int fontSizeSmall: 12
    
    // Font family
    property string fontFamily: "Microsoft YaHei, Arial, sans-serif"
    
    // Chat bubble colors
    property color userBubbleColor: isDark ? "#3b82f6" : "#60a5fa"   //User bubble (blue)
    property color aiBubbleColor: isDark ? "#374151" : "#e5e7eb"     //AI bubble (gray)
    property color userBubbleBorderColor: isDark ? "#2563eb" : "#3b82f6"
    property color aiBubbleBorderColor: isDark ? "#4b5563" : "#d1d5db"
    property color userTextColor: "#FFFFFF"
    property color aiTextColor: isDark ? "#E0E0E0" : "#333333"
    
    // Button colors
    property color buttonColor: isDark ? "#4b5563" : "#f3f4f6"
    property color buttonPressedColor: isDark ? "#374151" : "#e5e7eb"
    property color buttonBorderColor: isDark ? "#6b7280" : "#d1d5db"
    property color buttonTextColor: isDark ? "#E0E0E0" : "#333333"
    
    // Accent color
    property color accentColor: "#1E90FF"
    
    // Timestamp color
    property color timestampColor: isDark ? "#9ca3af" : "#6b7280"
}

