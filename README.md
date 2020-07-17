S3 Terraform Action
============================
Deploy an AWS S3 bucket using Terraform. This also generates an IAM policy that allows full read and write permissions to the S3 bucket. The policy can be attatched to an IAM user, role, or group to grant read and write permissions.

Usage
-----

```yaml
  - name: 'S3 Deploy'
      uses: apfm-actions/terraform-s3-action@master
      with:
        bucket_name: 'rickym-s3-test'
        enable_website: true
```


Inputs
-----

### destroy
Runs Terraform destroy to remove resources created by this action
- required: false
- default: false

### deploy
Runs Terraform apply to create/update resources created by this action
- required: false
- default: true

### plan
Runs Terraform plan to check the changes necessary to achieve the desired state
- required: false
- default: true

### bucket_name
The name of the bucket
- required: true

### acl
The canned ACL to apply. https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl. If enable_website is true, "public-read" ACL will be used
- required: false
- default: 'private'

### bucket_policy
A valid bucket policy JSON document. If enable_website is true, a public read bucket policy will be used
- required: false

### force_destroy
Allows Terraform to destroy a non-empty S3 bucket
- required: false
- default: false

### enable_website
If true, configures s3 bucket as a website
- required: false
- default: false

### website_index_document
Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders
- required: false
- default: 'index.html'

### website_error_document
An absolute path to the document to return in case of a 4XX error
- required: false

### website_redirect
A hostname to redirect all website requests for this bucket to. Hostname can optionally be prefixed with a protocol (http:// or https://) to use when redirecting requests. The default is the protocol that is used in the original request
- required: false

Outputs
-------

|         Context            |              Description                |
|----------------------------|-----------------------------------------|
| bucket_arn                 | The ARN of the bucket                   |
| website_endpoint           | The website endpoint, if the bucket is configured with a website. If not, this will be an empty string        |
| access_policy_arn          | The ARN of the IAM policy that grants read-write access to the bucket  |

Known Issues
-------
When utilizing the docker image version of this GitHub Action (uses: docker://apfm/terraform-s3-action:latest), input defaults are not working and all input variables must be explicitly defined. For variables without a default value, set the value to 'null' in order to omit the input.
