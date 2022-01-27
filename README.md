# checkmeoutdemo

**Background:**

We have been asked to create a website for a modern company that has recently migrated
their entire infrastructure to AWS. We need to demonstrate a basic website with some
text and an image, hosted and managed using modern standards and practices in AWS.
We can create your own application, or use open source or community software. The proof
of concept is to demonstrate hosting, managing, and scaling an enterprise-ready system.
This is not about website content or UI.

**Requirements:**

* Deliver the tooling to set up an application which displays a web page with text and
an image in AWS. (AWS free-tier is fine)
* Provide and document a mechanism for scaling the service and delivering the
content to a larger audience.
* Source code should be provided via a publicly accessible Github repository.
* Provide basic documentation to run the application along with any other
documentation you think is appropriate.
* Be prepared to explain your choices.


**Extra Mile Bonus (not a requirement)**

In addition to the above, time permitting, consider the following suggestions for taking your
implementation a step further.
* Monitoring/Alerting
* Security
* Automation
* Network diagrams

**Basic Design (v1):**

We are going to keep this POC very simple and stick with 3 main services. S3 for storage, Cloudfront for content distribution and Route53 for hosting/dns. 

![This is an image](/v1/docs/infra_v1.PNG)

This is a simple cost effectove solution that meets all the functional requirements.

**DevOps**

In this instance we will use github actions for our ci/cd pipelines, with terraform orhestrating our infrastructure. Some manual interention is required with Route53 for purchasing the domain and configuring dns.

![This is an image](/v1/docs/cicd.PNG)

**Github actions pipelines**

In the github/workflows folder there are two pipeline configurations, one for deploying the terraform, the othe rfor uploading the website content to s3.


