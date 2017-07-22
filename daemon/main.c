#include <stdio.h>
#include <unistd.h>
#include <stdarg.h>
#include <signal.h>
#include <syslog.h>
#include <main.h>

#define PID_FILE_PATH "/var/run/mydaemon.pid"


static int daemonized = 0; /* daemonized flag */
static volatile int sigterm = 0;
static void handle_sigterm(int sig) { sigterm = 1; }
static int daemonize(
    const char* pidfilepath,
    const char *syslog_ident,
    int syslog_option,
    int syslog_facility);


static int daemonize(
    const char* pidfilepath,
    const char *syslog_ident,
    int syslog_option,
    int syslog_facility)
{

    daemonized = 0; /* initialize */
    if (daemon(0, 0) != -1) {
        /* success to daemonize. */
        daemonized = 1;

        /* open syslog */
        if(syslog_ident) {
            openlog(syslog_ident, syslog_option, syslog_facility);
        }

        /* write daemon pid to the file */
        if(pidfilepath) {
            FILE* pidfile = fopen(pidfilepath, "w+");
            if (pidfile) {
                int pid = getpid();
                fprintf(pidfile, "%d\n", pid);
                fclose(pidfile);
            } else {
                syslog(LOG_ERR,
                        "daemonize() : failed to write pid.\n");
            }
        }
    }

    return daemonized;
}
/* The following codes are only sample */

static int mydaemon( void )
{
  syslog(LOG_INFO, "mydaemon started.\n");
  signal(SIGTERM, handle_sigterm);
  while(!sigterm) {
      do_main();
  }

  syslog(LOG_INFO, "mydaemon stopped.\n");
  return 0;
}

int main(int argc, char** argv)
{
    if(!daemonize(PID_FILE_PATH, "daemon", LOG_PID, LOG_DAEMON))
    {
        fprintf(stderr, "failed to daemonize.\n");
        return 2; /* fail to start daemon */
    }
    return mydaemon();
}
