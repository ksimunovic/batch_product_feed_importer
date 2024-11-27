# Publitas Backend Code Challenge

## Overview
This repository contains the solution for the Publitas Backend Code Challenge. The task is to parse a product feed XML file, extract product information, and send it to an external service in batches.

## Task Details
1. **Parse the product feed XML file.**
2. **Extract for each product:**
    - `id`
    - `title`
    - `description`
3. **Batch the products together and call the provided external service for each batch.**

### Batch Requirements
- The batch should be a JSON encoded array of the form:
  ```json
  [{id: 'id', title: 'title', description: 'description'}, ...]
  ```
- Each batch should be strictly below 5 megabytes in size.

## Deliverables
The project includes the following deliverables:
- Ruby code that meets the requirements outlined above.
- A README file with instructions on how to build and run the assignment.

### Running the Code
To run the assignment, use the following commands:

```bash
bundle install
ruby assignment.rb
```

## Extra Info
- The product feed format specification can be found [here](https://support.google.com/merchants/answer/7075225?hl=en).
- You may use any existing libraries but should not write your own XML parser.

## Requirements
- Code should be compatible with Ruby version 2.x.