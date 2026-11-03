import os
print(f"APP_NAME: {os.getenv('APP_NAME', 'brak')}")
print(f"APP_VERSION: {os.getenv('APP_VERSION', 'brak')}")
print(f"ENVIRONMENT: {os.getenv('ENVIRONMENT', 'brak')}")
print(f"DEBUG: {os.getenv('DEBUG', 'brak')}")
