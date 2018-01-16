# Check the application status
#
# This function checks if the application is running
check_status() {
    s=`ps aux | grep -- "-jar [a]irsonic.war" | tr -s " " | cut --delimiter=" " -f 2`
    
    if [ $s ] ; then
        # Can't use return as id can be > 255
        echo $s
    else
        echo 0
    fi
}

# Starts the application
start() {
    
    pid=$(check_status)
    
    if [ $pid -ne 0 ] ; then
        echo "The application is already started"
        exit 1
    fi
    
    # If the application isn’t running, starts it
    echo -n "Starting application: "
    
    # Redirects default and error output to a log file
    nohup java -Dairsonic.home=./home  -Dserver.port=4040 -jar airsonic.war >/dev/null 2>&1&
    
    echo "OK"
}

# Stops the application
stop() {
    
    pid=$(check_status)
    
    if [ $pid -eq 0 ] ; then
        echo "Application is already stopped"
        exit 1
    fi
    
    # Kills the application process
    echo -n "Stopping application: "
    kill -9 $pid &
    echo "OK"
}

# Show the application status
status() {
    
    pid=$(check_status)
    
    # If the PID was returned means the application is running
    if [ $pid -ne 0 ] ; then
        echo "Application is started"
    else
        echo "Application is stopped"
    fi
    
}

# Main logic, a simple case to call functions
case "$1" in
    start)
        start
    ;;
    stop)
        stop
    ;;
    status)
        status
    ;;
    restart|reload)
        stop
        start
    ;;
    *)
        echo "Usage: $0 {start|stop|restart|reload|status}"
        exit 1
esac

exit 0