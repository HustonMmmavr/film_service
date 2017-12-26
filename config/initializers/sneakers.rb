require 'sneakers'
p 'init'
Sneakers.configure(#daemonize: true,
                    amqp: "amqp://localhost",
                    log: "log/sneakers.log",
                    pid_path: "tmp/pids/sneakers.pid",
                    threads: 1,
                    workers: 4
)
Sneakers.logger.level = Logger::INFO # the default DEBUG is too noisy
