import Foundation

struct LoginQuery: Codable {

	var username: String
	var password: String
}

struct UserModel: Codable {

	var id: Int
	var username: String
	var firstName: String
	var lastName: String
	var email: String
	var password: String
	var phone: String
	var userStatus: Int
}

struct OrderModel: Codable {

	var id: Int
	var petId: Int
	var quantity: Int
	var shipDate: Date
	var complete: Bool
}

struct PetModel: Codable {

	var id: Int
	var name: String
	var tag: String?
}

enum PetStatus: String, Codable {

	case available
	case pending
	case sold
}
