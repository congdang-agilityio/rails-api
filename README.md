Auth Server
--
This is Authorization Server built by Ruby on Rails API. It holds the users table and just enough information to autenticate and authorize users. It's mean to be used in conjunction with another API or codebase that holds your application's business logic.

After authenticating a user, the Auth Server sends an [JWT (Json Web Token)](http://jwt.io) back to client. The client store this JWT and sends it back to the server with every subsequent request in the Authorization header.

### Gem List
1. **[rails 5.x](https://github.com/rails/rails)** - Ruby on Rails framework
2. **[pg](https://github.com/ged/ruby-pg)** - Postgres for database
3. **[jwt](https://github.com/jwt/ruby-jwt)** - A pure ruby implementation of JSON Web Token standard.
4. **[bcrypt](https://github.com/codahale/bcrypt-ruby)** - A easy way to keep your user's password secure.
5. **[puma](https://github.com/puma/puma)** - This is a simple, fast, threaded and highly concurrent HTTP 1.1 server for Ruby/Rack application.
6. **[rspec-rails](https://github.com/rspec/rspec-rails)** Testing framework for Rails

### Configuration Environment Variable
1. Application - You need to create the file called `.env` with below content (notice that the file won't be committed to source control)
	DATABASE_URL=postgres://<username>:<password>@host/<database_name>

2. TODO

### How to run

1. At root directory run `docker-compose up -d`

2. Accesss [http://localhost:3000/v1/users](http://localhost:3000/v1/users) to the sample list
3. Run `bundle exec rspec spec` to run all testcases.

### End Points
1. Registration

	`POST /v1/register`
2. Login
3. Reset Password
4. Forgot Password

#### API Document

Using [swagger-doc geam](https://github.com/richhollis/swagger-docs) to generate `API document` and using [swagger ui](https://github.com/swagger-api/swagger-ui) to view the document.

Run `http://localhost:3000/docs` to view the api document

Using the basic authenticate for login.

### Testing

	Bundle exec rspec spec
