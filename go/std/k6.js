
import http from "k6/http";

export const options = {
  discardResponseBodies: true,
  scenarios: {
    warm: {
      executor: 'constant-arrival-rate',
      duration: '60s',
      rate: 10,
      timeUnit: '1s',
      preAllocatedVUs: 10,
    },
    spike: {
      executor: 'constant-arrival-rate',
      duration: '60s',
      rate: 300,
      timeUnit: '1s',
      preAllocatedVUs: 10,
      startTime: '60s',
    },
  },
};

export default function () {
  http.get("http://localhost:8080/benchmark?n=100");
}
