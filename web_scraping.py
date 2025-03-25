import os
import requests
import zipfile
from bs4 import BeautifulSoup
from urllib.parse import urljoin

URL = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos"

# Set the headers to pretend that we are a browser
headers = {"User-Agent": "Mozilla/5.0"}
# Send a GET request to the URL
response = requests.get(URL, headers=headers)

folder = "pdf_files"
os.makedirs(folder, exist_ok=True)

# Check if the request was successful
if response.status_code == 200:
    # Parse the HTML content of the page
    soup = BeautifulSoup(response.content, "html.parser")

    # Find all the links in the page
    links = soup.find_all("a")

    # Find all PDF links in the page
    pdf_links = soup.find_all("a", href=lambda href: (href and href.endswith(".pdf")))
    print("Quantidade de PDF links encontrados:", len(pdf_links))

    # Print the URL of each link
    for link in pdf_links:
        # Find all Anexo links in the page
        if "Anexo" in urljoin(URL, link.get("href")):
            pdf_link = urljoin(URL, link.get("href"))

            # pdf name
            pdf_name = os.path.basename(pdf_link)
            print("PDF name: ", pdf_name)

            with requests.get(pdf_link, headers=headers) as req:

                # Check if the request was successful
                if req.status_code == 200:

                    # Save the PDF to a file
                    pdf_path = os.path.join(folder, pdf_name)
                    with open(pdf_path, "wb") as f:
                        for chunk in req.iter_content(chunk_size=1024):
                            f.write(chunk)
                        print("Downloaded pdf: ", pdf_link)

                else:
                    print("Failed to download pdf: ", req.status_code)
                    exit()

    # Save files in zip with zipfile
    with zipfile.ZipFile(f"AnexoPDF.zip", "w", zipfile.ZIP_DEFLATED) as zipf:
        with os.scandir(folder) as entries:
            for entry in entries:
                zipf.write(entry, os.path.basename(entry))
        print("Zip file created")


else:
    print("Failed to get the page: ", response.status_code)
