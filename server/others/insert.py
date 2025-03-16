import requests
BACKEND_URL = "http://localhost:8000/register"


users = [
    {"id": 0, "first_name": "John", "last_name": "Doe", "email": "john.doe@example.com", "password": "password123", "is_admin": True},
    {"id": 1, "first_name": "Jane", "last_name": "Smith", "email": "jane.smith@example.com", "password": "securepass456", "is_admin": False},
    {"id": 2, "first_name": "Alice", "last_name": "Brown", "email": "alice.brown@example.com", "password": "alicepass789", "is_admin": True},
    {"id": 3, "first_name": "Bob", "last_name": "Johnson", "email": "bob.johnson@example.com", "password": "bobsecure000", "is_admin": False},
    {"id": 4, "first_name": "John", "last_name": "Doe", "email": "john.doe@example.com", "password": "password123", "is_admin": True},
    {"id": 5, "first_name": "Jane", "last_name": "Smith", "email": "jane.smith@example.com", "password": "securepass456", "is_admin": False},
    {"id": 6, "first_name": "Alice", "last_name": "Brown", "email": "alice.brown@example.com", "password": "alicepass789", "is_admin": True},
    {"id": 7, "first_name": "Bob", "last_name": "Johnson", "email": "bob.johnson@example.com", "password": "bobsecure000", "is_admin": False},
]
def insert_users(users):
    for user in users:
        try:
            response = requests.post(BACKEND_URL, json=user)

            if response.status_code == 201:
                print(f"User {user['first_name']} {user['last_name']} inserted successfully.")
            else:
                print(f"Failed to insert user {user['first_name']} {user['last_name']}: {response.text}")
        except Exception as e:
            print(f"Error inserting user {user['first_name']} {user['last_name']}: {e}")

# Run the script
if __name__ == "__main__":
    insert_users(users)
