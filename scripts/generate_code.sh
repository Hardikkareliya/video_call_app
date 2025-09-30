#!/bin/bash

# Code Generation Script for Hipster Assignment Task
# This script generates Freezed and JSON serialization code

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

print_header() {
    echo -e "${PURPLE}[HEADER]${NC} $1"
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

# Function to clean generated files
clean_generated_files() {
    print_header "🧹 Cleaning previous generated files..."
    
    # Find and remove generated files
    find lib -name "*.freezed.dart" -type f -delete 2>/dev/null || true
    find lib -name "*.g.dart" -type f -delete 2>/dev/null || true
    
    print_success "Generated files cleaned"
}

# Function to run build runner clean
run_build_runner_clean() {
    print_status "Running build_runner clean..."
    flutter packages pub run build_runner clean
    print_success "Build runner clean completed"
}

# Function to generate code
generate_code() {
    print_header "⚡ Generating Freezed and JSON serialization code..."
    
    # Generate code with delete conflicting outputs
    flutter packages pub run build_runner build --delete-conflicting-outputs
    
    print_success "Code generation completed"
}

# Function to verify generated files
verify_generated_files() {
    print_status "Verifying generated files..."
    
    local freezed_files=$(find lib -name "*.freezed.dart" -type f | wc -l)
    local g_files=$(find lib -name "*.g.dart" -type f | wc -l)
    
    print_status "Generated $freezed_files .freezed.dart files"
    print_status "Generated $g_files .g.dart files"
    
    if [ "$freezed_files" -gt 0 ] || [ "$g_files" -gt 0 ]; then
        print_success "Generated files found"
    else
        print_warning "No generated files found - this might be normal if no Freezed classes exist"
    fi
}

# Function to show generated files
show_generated_files() {
    print_status "Generated files:"
    
    echo -e "\n${BLUE}Freezed files:${NC}"
    find lib -name "*.freezed.dart" -type f | sed 's/^/  /' || echo "  None found"
    
    echo -e "\n${BLUE}JSON serialization files:${NC}"
    find lib -name "*.g.dart" -type f | sed 's/^/  /' || echo "  None found"
}

# Function to run analysis
run_analysis() {
    print_status "Running code analysis..."
    flutter analyze
    print_success "Code analysis completed"
}

# Function to show help
show_help() {
    echo "Hipster Assignment Task - Code Generation Script"
    echo ""
    echo "Usage: $0 [OPTIONS] [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  generate          Generate Freezed and JSON code (default)"
    echo "  clean             Clean generated files only"
    echo "  watch             Watch for changes and auto-generate"
    echo "  verify            Verify generated files"
    echo "  show              Show generated files"
    echo "  analyze           Run code analysis"
    echo "  all               Clean, generate, and analyze"
    echo ""
    echo "Options:"
    echo "  --no-clean        Skip cleaning before generation"
    echo "  --no-analysis     Skip running analysis"
    echo "  --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 generate"
    echo "  $0 --no-clean watch"
    echo "  $0 all"
}

# Function to watch for changes
watch_changes() {
    print_header "👀 Watching for changes..."
    print_status "Press Ctrl+C to stop watching"
    flutter packages pub run build_runner watch
}

# Main script logic
main() {
    local command="generate"
    local clean=true
    local analysis=true
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --no-clean)
                clean=false
                shift
                ;;
            --no-analysis)
                analysis=false
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            generate|clean|watch|verify|show|analyze|all)
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
    
    # Check Flutter installation
    check_flutter
    
    # Execute command
    case $command in
        generate)
            if [ "$clean" = true ]; then
                clean_generated_files
                run_build_runner_clean
            fi
            generate_code
            verify_generated_files
            if [ "$analysis" = true ]; then
                run_analysis
            fi
            ;;
        clean)
            clean_generated_files
            run_build_runner_clean
            ;;
        watch)
            watch_changes
            ;;
        verify)
            verify_generated_files
            show_generated_files
            ;;
        show)
            show_generated_files
            ;;
        analyze)
            run_analysis
            ;;
        all)
            clean_generated_files
            run_build_runner_clean
            generate_code
            verify_generated_files
            show_generated_files
            run_analysis
            print_success "All tasks completed!"
            ;;
    esac
    
    print_success "Code generation process completed!"
}

# Run main function with all arguments
main "$@"
