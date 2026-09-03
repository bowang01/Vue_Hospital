import axios from "axios"
import {getToken} from "@/utils/storage.js";

// Create a singleton axios instance
const request = axios.create({
  baseURL: "",
  timeout: 8000
});
// Global interceptor, runs before every request
request.interceptors.request.use(config => {
  if (config.url && !/^https?:\/\//i.test(config.url)) {
    const path = config.url.replace(/^\/?hospital\/?/, "");
    config.url = "/hospital/" + path.replace(/^\//, "");
  }
  const token = getToken();
  if(token !== null){
      // Attach token to request headers
      config.headers["token"] = token;
  }
  return config;
  },error => {
  // Do something with request error
  return Promise.reject(error);
  });
// Export axios instance
export default request;
