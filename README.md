<h1 align="center">
  Vexgenda
</h1>

<p align="center">
  <img alt="License" src="https://img.shields.io/static/v1?label=license&message=MIT&color=4895ef&labelColor=0A1033">

![cover](.github/cover.png?style=flat)

##  📱 Preview
![1](https://user-images.githubusercontent.com/65514572/148657199-28b2c0c2-17b3-40f6-bf4a-15a9eb2b3e11.png) ![2](https://user-images.githubusercontent.com/65514572/148657260-a49b902a-bfde-4bef-a149-930a10342595.png) 
![3](https://user-images.githubusercontent.com/65514572/148657349-f689e945-1e62-4005-a0f1-a47d8c124085.png) ![4](https://user-images.githubusercontent.com/65514572/148657364-c72f5d07-83b2-44fa-8784-ca8d96c6fd7b.png)
![5](https://user-images.githubusercontent.com/65514572/148657369-81379955-d2da-4b51-a831-2696951c0df1.png)
![6](https://user-images.githubusercontent.com/65514572/148657373-2768e37c-8bb1-4f09-ba1b-d7ebcc2b79cd.png)
![7](https://user-images.githubusercontent.com/65514572/148657377-5d19fcbb-ffb8-4ac6-9af3-50bf5376992f.png)



  
## 💻 Projeto
Agenda de contatos personalizada, offline-first e no padrão MVVM. Integrada com os contatos da conta Google por meio da PeopleAPI. Criei, edite e exclua contatos de forma totalmente sincronizada.

  
## :hammer_and_wrench: Features 

-   [ ] Autenticação Google OAuth2;
-   [ ] Obtém contatos do usuário logado no Google (nome, telefones, emails e foto);
-   [ ] Lista os contatos do usuário;
-   [ ] Permite realizar pesquisa de contatos com sugestão;
-   [ ] Armazena contatos do usuário em banco local (RealmDB);
-   [ ] Funcionamento offline-first (alterações são salvas no banco local até serem sincronizadas na API);
-   [ ] Tratamentos de inputs com Regex e máscaras;


## ✨ Tecnologias

-   [ ] Swift
-   [ ] Google OAuth2.0  
-   [ ] People Api
-   [ ] PromiseKit
-   [ ] Async Storage
-   [ ] RealmDb
-   [ ] Alamofire

## Executando o projeto

Instale as dependências necessárias: 
```shell
pod install
```

Lembre-se de criar o seu App no Google Cloud, com função de autenticação OAuth 2.0 e acesso a People API.
Em seguida, substitua na classe PeopleAPi:
 
 ```swift
private let apiKey = "YOUR_API_KEY"
```
E na classe OAuthService:
 ```swift
URLQueryItem(name: "client_id", value: "YOUR_CLIENT_ID"),
            URLQueryItem(name: "redirect_uri", value: "YOUR_REDIRECT_URI"),
```




## 📄 Licença

Esse projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE.md) para mais detalhes.

<br />
