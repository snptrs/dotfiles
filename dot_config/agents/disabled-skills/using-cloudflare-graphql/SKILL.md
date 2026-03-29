---
name: using-cloudflare-graphql
description: "Query Cloudflare's GraphQL Analytics API via MCP. Use when asked to query Cloudflare analytics, zones, DNS, or other Cloudflare GraphQL data."
---

# Using Cloudflare GraphQL

Use the Cloudflare GraphQL MCP tools to query and interact with the user's Cloudflare account via the GraphQL Analytics API.

## Available Tools

| Tool | Description |
|------|-------------|
| `graphql_schema_search` | Search the Cloudflare GraphQL API schema for types, fields, and enum values matching a keyword |
| `graphql_schema_overview` | Fetch the high-level overview of the Cloudflare GraphQL API schema |
| `graphql_type_details` | Fetch detailed information about a specific GraphQL type |
| `graphql_complete_schema` | Fetch the complete schema (combines overview and important type details) |
| `graphql_query` | Execute a GraphQL query against the Cloudflare API |
| `graphql_api_explorer` | Generate a Cloudflare GraphQL API Explorer link with pre-populated query and variables |

## Tips

- Use `graphql_schema_search` or `graphql_schema_overview` first to discover the right types and fields before building a query
- Use `graphql_type_details` to drill into a specific type's fields and arguments
- Use `graphql_query` to execute queries for analytics data (HTTP traffic, firewall events, DNS, Workers, etc.)
- Use `graphql_api_explorer` to generate shareable links to the Cloudflare GraphQL API Explorer
