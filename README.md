# Product Feedback

<div align="center">
    <img src="./docs/preview.jpg" alt="Product Feedback" width="600px">
</div>

## Overview

Product Feedback is a web application designed to collect and manage user feedback on various products. It allows users to submit suggestions, comment on them, and view a roadmap of upcoming features.

## Features

- **User Authentication**: Secure user sessions.
- **Feedback Management**: Users can submit suggestions and comment on them.
- **Roadmap**: View the roadmap of upcoming features.
- **Health Check**: Endpoint to verify the application's health status.

## Installation

### Prerequisites

- Ruby on Rails
- PostgreSQL
- Docker (optional, for containerized deployment)

### Setup

1. Clone the repository:

   ```sh
   git clone https://github.com/your-user/product-feedback.git
   cd product-feedback
   ```

2. Install dependencies:

   ```sh
   bundle install
   yarn install
   ```

3. Set up the database:

   ```sh
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Start the Rails server:
   ```sh
   rails server
   ```

## Deployment

The application can be deployed using Docker. Ensure you have Docker installed and configured.

1. Build the Docker image:

   ```sh
   docker build -t your-user/product_feedback .
   ```

2. Run the Docker container:
   ```sh
   docker run -d -p 3000:3000 your-user/product_feedback
   ```

## Configuration

Configuration settings can be found in the `config` directory. Key files include:

- `config/deploy.yml`: Deployment configuration.
- `config/routes.rb`: Application routes.
- `config/application.rb`: Application configuration.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Contact

For any inquiries, please contact [your-email@example.com].
