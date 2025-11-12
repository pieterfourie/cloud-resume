output "api_url" {
  value = "${aws_apigatewayv2_api.httpapi.api_endpoint}/prod/count"
}

output "table_name" {
  value = aws_dynamodb_table.visitors.name
}
