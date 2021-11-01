//приватный ip
output "private_ip" {
 value = aws_instance.diplom_instance.*.private_ip
}
//публичный ip
output "public_ip" {
 value = aws_instance.diplom_instance.*.public_ip
}
