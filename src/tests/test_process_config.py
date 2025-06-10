import unittest
from unittest.mock import patch, MagicMock

# Sample YAML configuration as it would be contained in "../config.yml"
CONFIG_CONTENT = """
model:
  id: "model_123"
  file: "model.pkl"
  full_file_name: "full_model.pkl"
bucket:
  dev: "dev-bucket"
  prd: "prd-bucket"
"""


class TestProcessConfig(unittest.TestCase):
    @patch("boto3.resource")
    @patch("boto3.client")
    @patch("builtins.open", new_callable=unittest.mock.mock_open, read_data=CONFIG_CONTENT)
    def test_process_config(self, mock_open_file, mock_boto3_client, mock_boto3_resource):
        # Setup a fake S3 client and resource objects.
        fake_client = MagicMock()
        fake_resource = MagicMock()
        mock_boto3_client.return_value = fake_client
        mock_boto3_resource.return_value = fake_resource

        # Prepare a fake Bucket object with a fake object in its 'objects.all()' list.
        fake_bucket = MagicMock()
        fake_obj = MagicMock()
        # The key contains the model_id ("model_123") and ends with the model file ("model.pkl")
        fake_obj.key = "folder/model_123_model.pkl"
        fake_bucket.objects.all.return_value = [fake_obj]
        fake_resource.Bucket.return_value = fake_bucket

        # Import and invoke the process_config() function from your module.
        import src.server.models.process_config as system_under_test
        system_under_test.process_config()

        # Check that download_file was called once with the appropriate parameters
        fake_client.download_file.assert_called_once_with("dev-bucket", fake_obj.key, "full_model.pkl")

        # Check that put_object was called once with the appropriate parameters.
        fake_client.put_object.assert_called_once_with(
            Bucket="prd-bucket",
            Key="full_model.pkl",
            Body="model.pkl"
        )


if __name__ == '__main__':
    unittest.main()
