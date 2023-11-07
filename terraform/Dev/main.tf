module "api-product-api-demo-free" {
  source              = "./modules/apim-api/apim-product"
  apim_name           = var.apim_name
  resource_group_name = var.apim_resource_group
  product_id          = "API-DEMO-Free"
  description         = "This is the Free Product for API-DEMO"
  display_name        = "API-DEMO-Free"
  api_product_policy  = true
  product_xml_content = "./Dev/api-product-policy/api-demo-free.xml"
}

module "api-product-api-demo-paid" {
  source              = "./modules/apim-api/apim-product"
  apim_name           = var.apim_name
  resource_group_name = var.apim_resource_group
  product_id          = "API-DEMO-Paid"
  description         = "This is the Paid Product for API-DEMO"
  display_name        = "API-DEMO-Paid"
  api_product_policy  = true
  product_xml_content = "./Dev/api-product-policy/api-demo-paid.xml"
}

module "api-demo" {
  source              = "./modules/apim-api/apim-apis"
  apim_name           = var.apim_name
  resource_group_name = var.apim_resource_group
  api_name            = "LA-AIS-GF-NSD-API-DEMO-001"
  api_display_name    = "LA-AIS-GF-NSD-API-DEMO-001"
  api_path            = "api/api-demo"
  revision            = "1"
  # api_service_url = ""
  product_id = [module.api-product-api-demo-free.product_id]
  api-operations = [
    {
      api_operation_name        = "Get-All"
      api_operation_description = "Get all objects"
      api_operation_method      = "GET"
      api_operation_url         = "/all"
      api_operation_displayname = "Get All"
      template_parameter        = []
      response = [
        {
          status_code    = 200
          description    = "200 OK"
          representation = []
          header         = []
        }
      ]
      request = []
    },
    {
      api_operation_name        = "Post"
      api_operation_description = "Post all objects"
      api_operation_method      = "POST"
      api_operation_url         = "/"
      api_operation_displayname = "Post"
      template_parameter        = []
      response = [
        {
          status_code    = 200
          description    = "200 OK"
          representation = []
          header         = []
        }
      ]
      request = []
    }
  ]
  operation-policies = [
    {
      operation_id          = "Get-All"
      operation_xml_content = "./Dev/api-operation-policy/api-demo-get-all.xml"
    },
    {
      operation_id          = "Post"
      operation_xml_content = "./Dev/api-operation-policy/api-demo-post.xml"
    }
  ]
  api_policy      = true
  api_xml_content = "./Dev/api-policy/api-demo.xml"
  named_value = [
    {
      name         = "NV-AIS-GF-NSD-API-DEMO-001"
      display_name = "NV-AIS-GF-NSD-API-DEMO-001"
      secret       = true
      value        = null
      value_from_key_vault = [
        {
          secret_id = "https://kv-ais-ent-dev-omega-003.vault.azure.net/secrets/Alpha-Paid-Subs22PrimaryKey"
        }
      ]
    },
    {
      name                 = "NV-AIS-GF-NSD-API-DEMO-002"
      display_name         = "NV-AIS-GF-NSD-API-DEMO-002"
      secret               = true
      value                = "test"
      value_from_key_vault = []
    }
  ]
}

module "product-api" {
  source              = "./modules/apim-api/apim-product"
  apim_name           = var.apim_name
  resource_group_name = var.apim_resource_group
  product_id          = "product-api"
  description         = "This is the Products API"
  display_name        = "Product API"
  #group_names         = ["administrators", "test-product-group"]
}

module "product-api-v1" {
  source              = "./modules/apim-api/apim-product"
  apim_name           = var.apim_name
  resource_group_name = var.apim_resource_group
  product_id          = "product-api-v1"
  description         = "This is a product for v1 only"
  display_name        = "Product Api v1"
}

module "api-demo-v1" {
  source              = "./modules/apim-api/apim-apis"
  apim_name           = var.apim_name
  resource_group_name = var.apim_resource_group
  api_name            = "LA-AIS-GF-NSD-API-DEMO-v1"
  api_display_name    = "LA-AIS-GF-NSD-API-DEMO-v1"
  api_description     = "Sample Demo API"
  api_path            = "products"
  revision            = "1"
  # api_service_url = ""
  product_id = [module.product-api.product_id, module.product-api-v1.product_id]
  api-operations = [
    {
      api_operation_name        = "Is-Product-in-Stock"
      api_operation_description = "Get the stock details of a product by specifying the <i>product id</i>. The call can be made anonymously and does not require an auth token."
      api_operation_method      = "GET"
      api_operation_url         = "/products/stock/{id}"
      api_operation_displayname = "Is Product in Stock"
      template_parameter = [
        {
          name        = "id"
          description = null
          type        = "string"
          required    = true
          values      = ["123"]
        }
      ]
      response = [
        {
          status_code = 200
          description = "The response is returned when the status details for the <i>product id</i> are available"
          representation = [
            {
              content_type = "application/json"
              type_name    = null
              schema_id    = null
              example = [
                {
                  name        = "Sample"
                  description = "Sample Example"
                  value       = "{\"id\":123,\"isInStock\":true}"
                }
              ]
            },
            {
              content_type = "application/xml"
              type_name    = null
              schema_id    = "ProductDetail"
              example = [
                {
                  name        = "Sample"
                  description = "Sample Example"
                  value       = null
                }
              ]
            }
          ]
          header = [
            {
              name        = "x-products-api-location"
              description = null
              type        = "string"
              values      = ["West Europe"]
              required    = true
            },
            {
              name        = "x-products-api-monitor-status-location"
              description = null
              type        = "string"
              values      = ["https://samplelocation.net"]
              required    = false
            }
          ]
        },
        {
          status_code    = 400
          description    = "The response is returned when the product details for the <i>product id</i> are not available"
          representation = []
          header = [
            {
              name        = "x-products-api-location"
              description = null
              type        = "string"
              values      = ["West Europe"]
              required    = true
            }
          ]
        }
      ]
      request = []
    },
    {
      api_operation_name        = "Retrieve-Resource-By-ID"
      api_operation_description = "Get the details of a product by specifying the <i>product id</i>. The call can be made anonymously and does not require an auth token."
      api_operation_method      = "GET"
      api_operation_url         = "/products/{id}"
      api_operation_displayname = "Retrive Resource By ID"
      template_parameter = [
        {
          name        = "id"
          description = null
          type        = "string"
          required    = false
          values      = [""]
        }
      ]
      response = [
        {
          status_code    = 400
          description    = "The response is returned when the product details for the <i>product id</i> are not available"
          representation = []
          header         = []
        }
      ]
      request = [
        {
          description    = null
          representation = []
          query_parameter = [
            {
              name          = "filter"
              description   = null
              required      = false
              default_value = null
              values        = []
              type          = "string"
            }
          ]
        }
      ]
    }
  ]
  operation-policies = [
    {
      operation_id          = "Is-Product-in-Stock"
      operation_xml_content = "./Dev/api-operation-policy/Productinstock.xml"
    },
    {
      operation_id          = "Retrieve-Resource-By-ID"
      operation_xml_content = "./Dev/api-operation-policy/RetrieveresourcebyID.xml"
    }
  ]
  api_operation_tag = [
    {
      index        = 1
      operation_id = "Is-Product-in-Stock"
      name         = "Is-Product-in-Stock-GET"
      display_name = "GET"
    },
    {
      index        = 2
      operation_id = "Is-Product-in-Stock"
      name         = "IsProductinStockProductStock"
      display_name = "Product-Stocks"
    },
    {
      index        = 3
      operation_id = "Retrieve-Resource-By-ID"
      name         = "Is-Product-in-Stock-GET"
      display_name = "GET"
    },
    {
      index        = 4
      operation_id = "Retrieve-Resource-By-ID"
      name         = "RetrieveResourceByIDProductDetails"
      display_name = "Product-Details"
    },
    {
      index        = 5
      operation_id = "Is-Product-in-Stock"
      name         = "api-test"
      display_name = "api-test"
    },
    {
      index        = 6
      operation_id = "Is-Product-in-Stock"
      name         = "Complex"
      display_name = "Complex"
    }
  ]
  api_tag = [
    {
      index = 1
      name  = "StandaloneProxy"
    },
    {
      index = 2
      name  = "Medium"
    },
    {
      index = 3
      name  = "NSDSoldToCode"
    }
  ]
  enable_api_version = true
  api_version        = "V1"
  api_version_set_id = module.api-version-set-demo-v1.api_version_set_id
  api-schema = [
    {
      api_schema_id       = "ProductStatus"
      schema_content_type = "application/vnd.ms-azure-apim.swagger.definitions+json"
      schema_value        = null
      schema_definitions  = file("./Dev/api-schema/productStatus.json")
    },
    {
      api_schema_id       = "ProductDetail"
      schema_content_type = "application/vnd.ms-azure-apim.xsd+xml"
      schema_value        = file("./Dev/api-schema/ProductDetails.xsd")
      schema_definitions  = null
    }
  ]
}

module "api-demo-v2" {
  source              = "./modules/apim-api/apim-apis"
  apim_name           = var.apim_name
  resource_group_name = var.apim_resource_group
  api_name            = "LA-AIS-GF-NSD-API-DEMO-v2"
  api_display_name    = "LA-AIS-GF-NSD-API-DEMO-v2"
  api_path            = "products"
  revision            = "1"
  product_id          = [module.product-api.product_id, module.product-api-v1.product_id]
  api-operations = [
    {
      api_operation_name        = "Add-Product-Details"
      api_operation_description = "Add the details of a product by specifying the <i>product id</i>. The call must be made by an authenticated user. This is a sample API and no product details are actually updated."
      api_operation_method      = "POST"
      api_operation_url         = "/products/{id}"
      api_operation_displayname = "Is Product in Stock"
      template_parameter = [
        {
          name        = "id"
          description = null
          type        = "string"
          required    = true
          values      = []
        }
      ]
      response = [
        {
          status_code = 202
          description = "The response is returned when the product details for the <i>product id</i> are accepted for updating. It is a long-running background operation that may take upto 30 seconds to update the details."
          representation = [
            {
              content_type = "application/json"
              type_name    = null
              schema_id    = null
              example = [
                {
                  name        = "Sample"
                  description = "Sample Example"
                  value       = "{\"message\":\"Product details are being updated.\"}"
                }
              ]
            },
            {
              content_type = "application/xml"
              type_name    = null
              schema_id    = null
              example = [
                {
                  name        = "Sample"
                  description = "Sample Example"
                  value       = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><message>Product details are being updated.</message>"
                }
              ]
            }
          ]
          header = []
        },
        {
          status_code    = 400
          description    = "The response is returned when the product details for the <i>product id</i> are not available"
          representation = []
          header         = []
        }
      ]
      request = [
        {
          description     = "The request payload contains one or more product detail fields to be added."
          query_parameter = []
          representation = [
            {
              content_type = "application/json"
              type_name    = null
              schema_id    = "id-GetRequest"
              example = [
                {
                  name        = "Sample"
                  description = "Sample Example"
                  value       = "{\"id\":123,\"name\":\"House Plant\",\"category\":\"Home\",\"subcategory\":\"Decor\",\"color\":\"Green\",\"isInStock\":true}"
                }
              ]
            },
            {
              content_type = "application/xml"
              type_name    = null
              schema_id    = null
              example = [
                {
                  name        = "Sample"
                  description = "Sample Example"
                  value       = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><id>123</id><name>House Plant</name><category>Home</category><subcategory>Decor</subcategory><color>Green</color><isInStock>true</isInStock>"
                }
              ]
            }
          ]
        }
      ]
    }
  ]
  operation-policies = []
  enable_api_version = true
  api_version        = "V2"
  api_version_set_id = module.api-version-set-demo-v1.api_version_set_id
  api-schema = [
    {
      api_schema_id       = "id-GetRequest"
      schema_content_type = "application/vnd.ms-azure-apim.swagger.definitions+json"
      schema_value        = null
      schema_definitions  = file("./Dev/api-schema/id-GetRequest.json")
    }
  ]
}

module "api-version-set-demo-v1" {
  source                       = "./modules/apim-api/apim-api-version-set"
  api_version_set_name         = "Products"
  api_version_set_description  = "Product API version set"
  versioning_scheme            = "Query"
  version_query_name           = "api-version"
  api_version_set_display_name = "Products"
  apim_name                    = var.apim_name
  resource_group_name          = var.apim_resource_group
}


module "swagger-api" {
  source              = "./modules/apim-api/apim-apis"
  apim_name           = var.apim_name
  resource_group_name = var.apim_resource_group
  api_name            = "Swagger-API-001"
  api_display_name    = "Swagger-API-001"
  api_path            = "api/swagger-api-001"
  revision            = "1"
  # api_service_url = ""
  product_id = [module.api-product-api-demo-free.product_id]
  api_import = [{

    content_format = "swagger-json"
    content_value  = file("./Dev/api-operation-policy/petstoreswagger.json")
    wsdl_selector  = null
    }
  ]
  api_policy      = true
  api_xml_content = "./Dev/api-policy/petstoreapi.xml"

}

module "soap-api" {
  source              = "./modules/apim-api/apim-apis"
  apim_name           = var.apim_name
  resource_group_name = var.apim_resource_group
  api_name            = "SOAP-API-001"
  api_display_name    = "SOAP-API-001"
  api_path            = "api/soap-test-api-001"
  revision            = "1"
  # api_service_url = ""
  product_id = [module.api-product-api-demo-free.product_id]
  api_import = [{

    content_format = "wsdl"
    content_value  = file("./Dev/api-import/demo.wsdl")
    }
  ]
}

module "ivr-soap-api" {
  source              = "./modules/apim-api/apim-apis"
  apim_name           = var.apim_name
  resource_group_name = var.apim_resource_group
  api_name            = "SOAP-API-002"
  api_display_name    = "SOAP-API-002"
  api_path            = "api/soap-test-api-002"
  revision            = "1"
  api_type            = "soap"
  # api_service_url = ""
  product_id = [module.api-product-api-demo-free.product_id]
  api_import = [{

    content_format = "wsdl"
    content_value  = file("./Dev/api-import/ivr.wsdl")
    #wsdl_selector  = "wsdl"
    }
  ]
}

resource "azurerm_api_management_api" "api" {
  api_management_name   = var.apim_name
  display_name          = "SOAP-API-004"
  name                  = "SOAP-API-004"
  path                  = "api/soap-test-api-004"
  service_url           = "https://rtf01-uat-ipaaslb.shell.com/exp-mobility-loyalty-transactions-v1-uat/wsgetcardbalanceService/wsgetcardbalance​​​​​​​"
  protocols             = ["https"]
  resource_group_name   = var.apim_resource_group
  revision              = "1"
  subscription_required = true
  subscription_key_parameter_names {
    header = "Ocp-Apim-Subscription-Key"
    query  = "subscription-key"
  }
  api_type = "soap"
  import {
    content_format = "wsdl"
    content_value  = file("./Dev/api-import/ivr.wsdl")
    wsdl_selector {
      endpoint_name = "https://rtf01-uat-ipaaslb.shell.com/exp-mobility-loyalty-transactions-v1-uat/wsgetcardbalanceService/wsgetcardbalance​​​​​​​"
      service_name  = "https://rtf01-uat-ipaaslb.shell.com/exp-mobility-loyalty-transactions-v1-uat/wsgetcardbalanceService/wsgetcardbalance"
    }
  }
}
