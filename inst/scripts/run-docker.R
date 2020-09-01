pkgload::load_all(export_all = FALSE, helpers = FALSE)
docker <- Docker$new()
compose <- DockerCompose$new()

docker$kill_all_containers()$remove_dangling_images()

compose$restart("r-dev")
compose$browse_url("r-dev")
