import requests

def fetch_sample_data():
    url = 'https://jsonplaceholder.typicode.com/posts/1'

    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()

        data = response.json()
        print(f"Post title: {data.get('title')}")
        print(f"Post body: {data.get('body')}")

    except requests.exceptions.RequestException as err:
        print(f'Error fetching data: {err}')


if __name__ == '__main__':
    fetch_sample_data()
