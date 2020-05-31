import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    link: HttpLink(uri: 'http://192.168.101.29:80'),
    cache: InMemoryCache(),
  ),
);

final String getUsersQuery = """
query {
  users {
    name
    username
    email
    class
    grade
  }
}
""";
