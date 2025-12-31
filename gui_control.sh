#!/bin/bash
# Control script for CH57x Keyboard Configuration GUI

cd "$(dirname "$0")"

GUI_PORT=5001
PID_FILE="/tmp/keyboard_gui.pid"

function start_gui() {
    # Check if already running
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "✅ GUI is already running on http://localhost:$GUI_PORT"
        echo "   PID: $(cat $PID_FILE)"
        return 0
    fi

    echo "🚀 Starting keyboard configuration GUI..."

    # Check if venv exists
    if [ ! -d "venv" ]; then
        echo "📦 Creating virtual environment..."
        python3 -m venv venv
        source venv/bin/activate
        pip install flask pyyaml
    else
        source venv/bin/activate
    fi

    # Start GUI in background
    nohup python3 keyboard_config_gui.py > gui.log 2>&1 &
    GUI_PID=$!
    echo $GUI_PID > "$PID_FILE"

    # Wait a moment for it to start
    sleep 2

    # Check if it's actually running
    if kill -0 $GUI_PID 2>/dev/null; then
        echo "✅ GUI started successfully!"
        echo "   PID: $GUI_PID"
        echo "   URL: http://localhost:$GUI_PORT"
        echo "   Log: gui.log"
    else
        echo "❌ Failed to start GUI. Check gui.log for errors."
        rm -f "$PID_FILE"
        return 1
    fi
}

function stop_gui() {
    echo "🛑 Stopping keyboard configuration GUI..."

    # Try PID file first
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 $PID 2>/dev/null; then
            kill $PID
            echo "   Sent stop signal to PID $PID"
            sleep 1
        fi
        rm -f "$PID_FILE"
    fi

    # Kill any remaining processes
    pkill -f "python3.*keyboard_config_gui.py" 2>/dev/null

    # Check if port is still in use
    if lsof -ti:$GUI_PORT >/dev/null 2>&1; then
        echo "⚠️  Port $GUI_PORT still in use, force killing..."
        lsof -ti:$GUI_PORT | xargs kill -9 2>/dev/null
    fi

    echo "✅ GUI stopped"
}

function restart_gui() {
    echo "🔄 Restarting keyboard configuration GUI..."
    stop_gui
    sleep 1
    start_gui
}

function status_gui() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        PID=$(cat "$PID_FILE")
        echo "✅ GUI is running"
        echo "   PID: $PID"
        echo "   URL: http://localhost:$GUI_PORT"

        # Show recent log entries
        if [ -f "gui.log" ]; then
            echo ""
            echo "📋 Recent log entries:"
            tail -5 gui.log | sed 's/^/   /'
        fi
    else
        echo "❌ GUI is not running"
        [ -f "$PID_FILE" ] && rm -f "$PID_FILE"
    fi
}

function show_help() {
    echo "CH57x Keyboard Configuration GUI Control"
    echo ""
    echo "Usage: $0 {start|stop|restart|status}"
    echo ""
    echo "Commands:"
    echo "  start    - Start the GUI server"
    echo "  stop     - Stop the GUI server"
    echo "  restart  - Restart the GUI server"
    echo "  status   - Check if GUI is running"
    echo ""
    echo "The GUI will be available at: http://localhost:$GUI_PORT"
}

# Main command handling
case "${1:-}" in
    start)
        start_gui
        ;;
    stop)
        stop_gui
        ;;
    restart)
        restart_gui
        ;;
    status)
        status_gui
        ;;
    *)
        show_help
        ;;
esac
