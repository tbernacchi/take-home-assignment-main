# Task 1: Dockerize
### Exercise Goals

This is your first task in out assignment. Here you are supposed to build a Dockfile with a Go Webserver within. 

* Create a `Dockerfile`;
  * Build `golang` executable inside your `Dockerfile`;
  * Let the executable run as you load the image;
* Build a `Docker` image using your `Dockerfile`;
* Run your new created image and get a `200` HTTP Code once your container is running;

### Expected Output

Please, provide us with the `Dockerfile` you created. Your `Dockerfile` is supposed to:
* Copy our source code inside this folder to the image;
* Build the binary from our source code inside the image;
* Run the binary at the end of the image;

[Optional] You can also share screenshots of your progress.

### Next steps?

Once you complete this task, you can proceed to the [Kubernetes](../kubernetes) task;

---

### Usage
```bash
docker buildx build --platform linux/arm64 -t <USER>/<REPO>:v0.0.1 --push .
docker run -it -d -p 8080:8080 <USER>/<REPO>:v0.0.1
docker exec -it <CONTAINER_ID> curl -o /dev/null -s -w "%{http_code}\n" localhost:8080
```
