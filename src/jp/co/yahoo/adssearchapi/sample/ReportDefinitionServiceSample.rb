# Copyright (C) 2020 Yahoo Japan Corporation. All Rights Reserved.

# load the gem
require 'openapi_client'
require 'yaml'
require 'erb'
# setup authorization
file = File.read("conf/config.yml")
converted = ERB.new(file).result
conf = YAML.load(converted)
OpenapiClient.configure do |config|
  # Configure OAuth2 access token for authorization: oAuth
  config.access_token = conf["access_token"]
end

api_instance = OpenapiClient::ReportDefinitionServiceApi.new

base_account_id = conf["base_account_id"]

# Add
opts = {
    report_definition_service_operation: OpenapiClient::ReportDefinitionServiceOperation.new(
        {
            account_id: conf["account_id"],
            operand: [
                OpenapiClient::ReportDefinition.new(
                    fields: ['IMPS', 'CLICKS'],
                    report_type: OpenapiClient::ReportDefinitionServiceReportType::ACCOUNT,
                    report_date_range_type: OpenapiClient::ReportDefinitionServiceReportDateRangeType::YESTERDAY,
                    report_name: 'Report Sample'
                )
            ]
        }
    ) # ReportDefinitionServiceOperation
}

job_id = nil
begin
  result = api_instance.report_definition_service_add_post(base_account_id, opts)
  job_id = result.rval.values[0].report_definition.report_job_id
rescue OpenapiClient::ApiError => e
  puts "Exception when calling ReportDefinitionServiceApi->report_definition_service_add_post: #{e}"
  exit
end

# Get
opts = {
    report_definition_service_selector: OpenapiClient::ReportDefinitionServiceSelector.new(
        {
            account_id: conf["account_id"],
            report_job_ids: [job_id]
        }
    ) # ReportDefinitionServiceSelector |
}

begin
  result = api_instance.report_definition_service_get_post(base_account_id, opts)
  job_status = result.rval.values[0].report_definition.report_job_status
  num = 0
  while job_status != OpenapiClient::ReportDefinitionServiceReportJobStatus::COMPLETED do
    sleep(1)
    result = api_instance.report_definition_service_get_post(base_account_id, opts)
    job_status = result.rval.values[0].report_definition.report_job_status
    num += 1
    if num == 100
      puts "Processing does not end."
      exit
    end
  end
rescue OpenapiClient::ApiError => e
  puts "Exception when calling ReportDefinitionServiceApi->report_definition_service_get_post: #{e}"
end

#download
opts = {
    report_definition_service_download_selector: OpenapiClient::ReportDefinitionServiceDownloadSelector.new(
        {
            account_id: conf["account_id"],
            report_job_id: job_id
        }
    ) # ReportDefinitionServiceDownloadSelector |
}

begin
  filename = "download/sample.csv"
  open(api_instance.report_definition_service_download_post(base_account_id, opts)) do |file|
    open(filename, "w+b") do |out|
      out.write(file.read)
    end
  end

rescue OpenapiClient::ApiError => e
  puts "Exception when calling ReportDefinitionServiceApi->report_definition_service_download_post: #{e}"
end
