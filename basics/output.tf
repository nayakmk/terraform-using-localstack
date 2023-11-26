# Output Block

output "petname" {
  description = "The random pet"
  value = random_pet.petname.id
}