const authConfig = {
    UserPoolId: '${aws_cognito_user_pool.user_pool.id}',
    ClientId: '${aws_cognito_user_pool_client.client.id}',
    Region: '${var.aws_region}',
    IdentityPoolId: '${aws_cognito_identity_pool.identity_pool.id}'
};