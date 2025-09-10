# Comunicação Interprocessos | 10/09/2025

![Image](https://github.com/user-attachments/assets/25085f51-7f45-4a39-b038-be3504c723c3)
![Image](https://github.com/user-attachments/assets/d28e81f8-76eb-4f39-9bcf-b7d37f4debf4)

- Sleep é para o sistema esperar e wakeup é para o sistema agir
  - Serve para evitar a espera ativa.  

![Image](https://github.com/user-attachments/assets/e8251b5f-f501-42b3-abb0-f8160fe8d522)
![Image](https://github.com/user-attachments/assets/3b5c9e33-8bc6-4d30-a5e5-55f6d3a0770e)
![Image](https://github.com/user-attachments/assets/6166fd36-4d93-43b4-b519-f56480d62e89)
![Image](https://github.com/user-attachments/assets/6dbc60db-db0a-4c97-ac47-ad219e062bef)
![Image](https://github.com/user-attachments/assets/742fe159-7084-4159-ac47-5fe6c81fa682)
![Image](https://github.com/user-attachments/assets/f9433c22-7fcb-4bbc-91ef-ae83ebb9cc9b)

- A região critica fica entre o down e o mutex.
- empty e mutex estão invertidos.
- Se o N = 0, entra em um loop infinito.

![Image](https://github.com/user-attachments/assets/c9bf03cc-d5f5-41ac-856b-a78359054790)
![Image](https://github.com/user-attachments/assets/fb125095-0ee9-41b2-acf7-2d5abd03a5a9)


- O escalonador é o que seleciona o processo que será executado.
