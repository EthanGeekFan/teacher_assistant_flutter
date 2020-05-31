import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

GraphQLClient graphQLClient = GraphQLClient(
  link: HttpLink(uri: 'http://192.168.101.29:80'),
  cache: InMemoryCache(),
);

ValueNotifier<GraphQLClient> client = ValueNotifier(graphQLClient);

final String getUsersQuery = """
query {
  users {
    name
    username
    email
    class
    grade
    age
  }
}
""";

final String userLogin = """
query userLoginQuery(\$username: String, \$password: String) {
  users(username: \$username, password: \$password) {
    name
    class
    grade
    age
    username
    email
    avatar_url
  }
}
""";

final String getUserInfo = """
query userLoginQuery(\$username: String) {
  users(username: \$username) {
    name
    class
    grade
    age
    username
    email
    avatar_url
  }
}
""";

final String updatePasswordWithPassword = """
mutation updatePasswordWithPassword(
  \$username: String
  \$oldPassword: String
  \$newPassword: String
) {
  updateUser(
    filter: { username: \$username, password: \$oldPassword }
    password: \$newPassword
  )
}
""";

final String updatePasswordWithEmail = """
mutation updatePasswordWithEmail(
  \$username: String
  \$email: String
  \$password: String
) {
  updateUser(
    filter: { username: \$username, email: \$email }
    password: \$password
  )
}
""";

final String createNewAccount = """

""";
