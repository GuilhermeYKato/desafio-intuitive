import pdfplumber
import pandas as pd
from tqdm import tqdm

# Path to the PDF file
pdf_path = "pdf_files/Anexo_I_Rol_2021RN_465.2021_RN627L.2024.pdf"

# Output CSV
csv_output = "Teste_Guilherme_Yamamoto_Kato.csv"

# Empty list to store extracted data
data = []

# Open the PDF file
with pdfplumber.open(pdf_path) as pdf:
    print("Extracting data from PDF")
    print(f"Number of pages: {len(pdf.pages)}")

    # Loop through the pages
    for page in tqdm(pdf.pages, desc="Processing Pages", unit="page"):
        # Extract text from the page
        table = page.extract_table()

        # Check the page number to extract header one time
        if page.page_number == 3:
            data.extend(table)
        elif page.page_number > 3:
            data.extend(table[1:])

# Convert the extracted data into a DataFrame
df = pd.DataFrame(data)

# Replace "OD" with "Seg. Odontológica"
print("Replacing OD with Seg. Odontológica")
df.iloc[1:] = df.iloc[1:].replace("OD", "Seg. Odontológica", regex=True)

# Replace "AMB" with "Seg. Ambulatorial"
print("Replacing AMB with Seg. Ambulatorial")
df.iloc[1:] = df.iloc[1:].replace("AMB", "Seg. Ambulatorial", regex=True)

# Remove all \n between ""
df = df.replace(r"\n", "", regex=True)

# Save DataFrame to a CSV file
df.to_csv(csv_output, index=False, header=False)

print(f"Data extracted from pdf")
