import { ServerUnaryCall, sendUnaryData, Metadata, status } from '@grpc/grpc-js';
import { checkRoleGRPC } from '../commons/middleware';

const rolePermissions: { [key: string]: string[] } = {
  '/location.LocationService/GetLocation': ['admin', 'user'],
};

export async function authInterceptor(
  call: ServerUnaryCall<any, any>,
  callback: sendUnaryData<any>,
  next: (error?: Error | null) => void
) {
  const metadata: Metadata = call.metadata;
  const token = metadata.get('authorization')[0];
  const method = call.getPath()

  if (!token) {
    return callback({
      code: status.UNAUTHENTICATED,
      message: 'Invalid or missing token',
    });
  }

  const allowedRoles = rolePermissions[method];
  if (!allowedRoles) {
    return callback({
      code: status.PERMISSION_DENIED,
      message: 'No roles defined for this method',
    });
  }

  const hasAccess = await checkRoleGRPC(allowedRoles, token.toString());
  if (!hasAccess) {
    return callback({
      code: status.PERMISSION_DENIED,
      message: 'Access denied',
    });
  }

  next();
}