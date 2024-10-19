{
  username = "hydenix";
  gitUser = "hydenix";
  gitEmail = "exampleEmail";
  host = "hydenix";
  /*
    Default password is required for sudo support in systems
    !REMEMBER TO USE passwd TO CHANGE THE PASSWORD!
    post install this will run passwd by default
  */
  defaultPassword = "changeme";
  vm = {
    # 4 GB minimum
    memorySize = 8192;
    # 2 cores minimum
    cores = 4;
    # 20GB minimum
    diskSize = 20480;
  };
}
