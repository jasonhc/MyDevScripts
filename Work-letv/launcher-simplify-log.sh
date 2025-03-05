# Simplify log of Launcher app, output simplified log to stdout.
# Usage: xxx <input log file>  <pid of Launcher>
#        <input log file> can be "-" to use stdin as input

if [ $# -lt 2 ]; then
    echo "Simplify log of Launcher app, output simplified log to stdout."
    echo "Usage: xxx <input log file>  <pid of Launcher>"
    echo "       <input log file> can be \"-\" to use stdin as input"
    exit 1
fi

# UNUSED_LOG_REGEX="(MethodHandler|ControllableEcoImageView|EcoBitmap:DraweeEventTracker|ReportLogUtil -- |GrapUtil|chatty |DataReporter|SdkReporter|zygote\s+|System\.out)\("
UNUSED_LOG_REGEX="MethodHandler:|ControllableEcoImageView:|EcoBitmap:DraweeEventTracker:|ReportLogUtil -- |GrapUtil:|chatty |DataReporter:|SdkReporter:|zygote\s+:|System\.out:"
logFile=$1
launcherPid=$2

#if [ ! -f $logFile ]; then
#    echo "File $logFile does not exist"
#    exit 1
#fi

if [ "$logFile" == "-" ]; then
    # use stdin as input
    logFile=""
fi

egrep "$launcherPid( |\)|-)" $logFile | grep -vE "$UNUSED_LOG_REGEX" | tr -s ' ' | cut -d ' ' -f 5-
# egrep "$launcherPid( |\))" $logFile | grep -vE "$UNUSED_LOG_REGEX" | tr -s ' ' | cut -d ' ' -f 5-
