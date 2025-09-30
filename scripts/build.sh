#!/bin/bash

# Build Script for Hipster Assignment Task
# This script automates the build process for different platforms and environments

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Flutter installation
check_flutter() {
    if ! command_exists flutter; then
        print_error "Flutter is not installed or not in PATH"
        exit 1
    fi
    
    print_status "Flutter version: $(flutter --version | head -n 1)"
}

# Function to clean project
clean_project() {
    print_status "Cleaning project..."
    flutter clean
    flutter pub get
    flutter packages pub run build_runner build --delete-conflicting-outputs
    print_success "Project cleaned successfully"
}

# Function to build Android APK
build_android_apk() {
    local build_type=$1
    print_status "Building Android APK ($build_type)..."
    
    if [ "$build_type" = "release" ]; then
        flutter build apk --release
        print_success "Android APK (release) built successfully"
        print_status "APK location: build/app/outputs/flutter-apk/app-release.apk"
    else
        flutter build apk --debug
        print_success "Android APK (debug) built successfully"
        print_status "APK location: build/app/outputs/flutter-apk/app-debug.apk"
    fi
}

# Function to build Android App Bundle
build_android_bundle() {
    print_status "Building Android App Bundle..."
    flutter build appbundle --release
    print_success "Android App Bundle built successfully"
    print_status "AAB location: build/app/outputs/bundle/release/app-release.aab"
}

# Function to build iOS
build_ios() {
    local build_type=$1
    print_status "Building iOS ($build_type)..."
    
    if [ "$build_type" = "release" ]; then
        flutter build ios --release
        print_success "iOS (release) built successfully"
    else
        flutter build ios --debug
        print_success "iOS (debug) built successfully"
    fi
}

# Function to run tests
run_tests() {
    print_status "Running tests..."
    flutter test
    print_success "All tests passed"
}

# Function to analyze code
analyze_code() {
    print_status "Analyzing code..."
    flutter analyze
    print_success "Code analysis completed"
}

# Function to show help
show_help() {
    echo "Hipster Assignment Task - Build Script"
    echo ""
    echo "Usage: $0 [OPTIONS] [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  android-debug     Build Android APK (debug)"
    echo "  android-release   Build Android APK (release)"
    echo "  android-bundle    Build Android App Bundle (release)"
    echo "  ios-debug         Build iOS (debug)"
    echo "  ios-release       Build iOS (release)"
    echo "  test              Run tests"
    echo "  analyze           Analyze code"
    echo "  clean             Clean project"
    echo "  generate          Generate Freezed and JSON code"
    echo "  all               Build all platforms (release)"
    echo ""
    echo "Options:"
    echo "  --no-clean        Skip cleaning before build"
    echo "  --no-test         Skip running tests"
    echo "  --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 android-release"
    echo "  $0 --no-clean ios-debug"
    echo "  $0 all"
}

# Main script logic
main() {
    local command=""
    local clean=true
    local test=true
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --no-clean)
                clean=false
                shift
                ;;
            --no-test)
                test=false
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            android-debug|android-release|android-bundle|ios-debug|ios-release|test|analyze|clean|all)
                command=$1
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Check if command is provided
    if [ -z "$command" ]; then
        print_error "No command provided"
        show_help
        exit 1
    fi
    
    # Check Flutter installation
    check_flutter
    
    # Clean project if requested
    if [ "$clean" = true ] && [ "$command" != "clean" ]; then
        clean_project
    fi
    
    # Run tests if requested
    if [ "$test" = true ] && [ "$command" != "test" ] && [ "$command" != "analyze" ] && [ "$command" != "clean" ]; then
        run_tests
    fi
    
    # Execute command
    case $command in
        android-debug)
            build_android_apk "debug"
            ;;
        android-release)
            build_android_apk "release"
            ;;
        android-bundle)
            build_android_bundle
            ;;
        ios-debug)
            build_ios "debug"
            ;;
        ios-release)
            build_ios "release"
            ;;
        test)
            run_tests
            ;;
        analyze)
            analyze_code
            ;;
        clean)
            clean_project
            ;;
        generate)
            print_status "Generating Freezed and JSON code..."
            ./scripts/generate_code.sh
            ;;
        all)
            print_status "Building all platforms..."
            build_android_apk "release"
            build_android_bundle
            build_ios "release"
            print_success "All platforms built successfully"
            ;;
    esac
    
    print_success "Build process completed!"
}

# Run main function with all arguments
main "$@"
