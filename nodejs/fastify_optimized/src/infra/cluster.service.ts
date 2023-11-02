import { Injectable } from '@nestjs/common';
const cluster = require('cluster');
const os = require('os');

@Injectable()
export class ClusterService {
    static clusterize(bootstrap: () => any): void {
    const numCPUs = os.cpus().length;

    if (cluster.isMaster) {
      console.log(`Master ${process.pid} is running`);

      for (let i = 0; i < numCPUs; i++) {
        cluster.fork();
      }

      cluster.on('exit', (worker) => {
        console.log(`Worker ${worker.process.pid} died`);
      });
    } else {
      bootstrap();
      console.log(`Worker ${process.pid} started`);
    }
  }
}