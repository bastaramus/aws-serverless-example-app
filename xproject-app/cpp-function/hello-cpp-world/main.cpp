// main.cpp
#include <aws/lambda-runtime/runtime.h>
#include <aws/core/utils/json/JsonSerializer.h>
#include <aws/core/utils/memory/stl/SimpleStringStream.h>

using namespace aws::lambda_runtime;

invocation_response my_handler(invocation_request const& request)
{

   using namespace Aws::Utils::Json;

   JsonValue resp;
   resp.WithString("body", "Hello World!");
   return invocation_response::success(resp.View().WriteCompact(), "application/json");
}

int main()
{
   run_handler(my_handler);
   return 0;
}