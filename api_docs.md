# Autorização

## Criação de usuário

Para todas as requisições, será necessário um usuário autenticado.
Dito isso, o primeiro passo para o uso da API será a criação de um usuário

| URL            | Método |
| :------------- | :----- |
| `/api/v1/user` | `POST` |

### Exemplo de requisição

```json
{
  "name": "Jane Doe",
  "account": {
    "email": "jane@mail.com",
    "password": "janepasswd123"
  }
}
```

### **Status 201 (CREATED)**
```json
{
  "id": 4,
  "name": "Roger",
  "account": {
    "id": 12,
    "email": "roger12324@mail.com"
  }
}
```

### **Status 400 (BAD REQUEST)**
Para erros de validação, será retornado um payload com uma chave `errors` contendo detalhes sobre a validação

Por exemplo, para emails inválidos:

```json
{
  "errors": {
    "account": {
      "email": ["has invalid format"]
    }
  }
}
```
