output "jenkins_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "k8_master_public_ip" {
  value = aws_instance.k8_master.public_ip
}

output "k8_worker_public_ip" {
  value = aws_instance.k8_worker.public_ip
}