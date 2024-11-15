import {Request, Response} from 'express';
import {connectionManager} from "./connection.manager";
import {Response200, Response503, ResponseApi} from "../../../commons/TypeResponse";
import {validateError} from "../../../commons/TypeError";
import {FavorRepository} from "../repository/favor.repository";
import {FavorService} from "../service/favor.service";
import {FavorEntity} from "../interface/favor.entity";
import {LoginResponse} from "../../../auth/interface/login.type";


const createFavor = async (req: Request, res: Response) => {
    try {
        const { id_customer, customer_direction, collection_points, products, user } = req.body;
        const payload = {
            id_customer,
            customer_direction,
            collection_points,
            products
        } as FavorEntity;

        const repository: FavorRepository = new FavorRepository();
        const service: FavorService = new FavorService(repository);
        await service.createFavor(payload);

        const response: ResponseApi<any> = Response200({ message: 'Favor created successfully' });
        res.status(response.code).json(response);
    } catch (e) {
      console.log(e)
        const error: ResponseApi<any> = validateError(e as Error);
        res.status(error.code).json(error);
    }
}

const setupStatusSSE = async (req: Request, res: Response): Promise<void> => {
  try {
    const { user } = req.body;
    const { id } = req.params;
    const connectionId = `cou-${id}-${user.uid}`;
    const fieldId = id;

    const existingConnection = connectionManager.getConnection(connectionId);
    if (existingConnection) {
      existingConnection.res.end();
      connectionManager.removeConnection(connectionId);
    }

    const repository: FavorRepository = new FavorRepository();
    const service: FavorService = new FavorService(repository);

    // Configure SSE
    res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive'
    });
    let lastStatus: string | null = null;

    // Send status every 10 seconds
    const sendStatus = async () => {
      try {
        const result = await service.getFavorStatus(id);
        // Send only if status has changed
        if (lastStatus !== result.get('status')) {
          lastStatus = result.get('status');
          res.write(`data: ${JSON.stringify(Object.fromEntries(result))}\n\n`);

          // If status is "FINISHED", close connection
          if (result.get('status') === 'Finished') {
            clearInterval(intervalId);
            connectionManager.removeConnection(connectionId);
            res.end();
          }
        }
      } catch (error) {
        console.error('Error fetching status:', error);
        res.write(`event: error\ndata: ${JSON.stringify({ message: 'Error fetching status' })}\n\n`);

        // If error is critical, close connection
        if (error instanceof Error && error.message.includes('CRITICAL')) {
          clearInterval(intervalId);
          connectionManager.removeConnection(connectionId);
          res.end();
        }
      }
    };

    // Add connection to manager
    const intervalId = setInterval(sendStatus, 10000);
    const connectionAdded = connectionManager.addConnection(connectionId, res, intervalId, fieldId);

    if (!connectionAdded) {
      const response: ResponseApi<any> = Response503({ message: 'Server is at maximum capacity' });
      res.status(response.code).json(response);
      return;
    }

    // Send the initial status
    await sendStatus();

    // Manage connection close
    req.on('close', () => {
      clearInterval(intervalId);
      connectionManager.removeConnection(connectionId);
    });
  } catch (e) {
    const error: ResponseApi<any> = validateError(e as Error);
    if (!res.headersSent) {
      res.status(error.code).json(error);
    }
  }
};

const updateCourierStatus = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { newStatus, user, cost, receipt } = req.body;

    const repository: FavorRepository = new FavorRepository();
    const service: FavorService = new FavorService(repository);
    await service.updateFavorStatus_courier(id, user.uid, newStatus, cost, receipt);
    const result = await service.getFavorStatus(id);

    // Get all connections for this field
    const connections = connectionManager.getConnectionsByFieldId(id);

    // Send the new status to all connections
    connections.forEach((connection) => {
      connection.res.write(`data: ${JSON.stringify(Object.fromEntries(result))}\n\n`);

      // If status is "FINISHED", close connection
      if (newStatus === 'Finished') {
        connectionManager.removeConnection(connection.connectionId);
        connection.res.end();
      }
    });

    const response: ResponseApi<any> = Response200({ message: 'Status updated successfully' });
    res.status(response.code).json(response);
  } catch (e) {
    console.log(e)
    const error: ResponseApi<any> = validateError(e as Error);
    if (!res.headersSent) {
      res.status(error.code).json(error);
    }
  }
};

const acceptFavor = async (req: Request, res: Response) => {
    try {
        const { no_order } = req.params;
        const { location, courier_id } = req.body;

        const repository: FavorRepository = new FavorRepository();
        const service: FavorService = new FavorService(repository);
        await service.acceptFavor(no_order, location, courier_id);

        const response: ResponseApi<any> = Response200({ message: 'Favor accepted successfully' });
        res.status(response.code).json(response);
    } catch (e) {
        console.log(e)
        const error: ResponseApi<any> = validateError(e as Error);
        res.status(error.code).json(error);
    }
}

const cancelFavor = async (req: Request, res: Response) => {
    try {
        const { no_order } = req.params;
        const { user } = req.body;

        const repository: FavorRepository = new FavorRepository();
        const service: FavorService = new FavorService(repository);
        await service.cancelFavor(no_order, user.uid);

        const response: ResponseApi<any> = Response200({ message: 'Favor canceled successfully' });
        res.status(response.code).json(response);
    } catch (e) {
        console.log(e)
        const error: ResponseApi<any> = validateError(e as Error);
        res.status(error.code).json(error);
    }
}

const rejectFavor = async (req: Request, res: Response) => {
    try {
        const { no_order } = req.params;
        const { courier_id } = req.body;

        const repository: FavorRepository = new FavorRepository();
        const service: FavorService = new FavorService(repository);
        await service.rejectFavor(no_order, courier_id);

        const response: ResponseApi<any> = Response200({ message: 'Favor rejected successfully' });
        res.status(response.code).json(response);
    } catch (e) {
        console.log(e)
        const error: ResponseApi<any> = validateError(e as Error);
        res.status(error.code).json(error);
    }
}

// Middleware to monitor active connections
const monitorConnections = (req: Request, res: Response, next: Function) => {
    const activeConnections = connectionManager.getActiveConnections();
    const response: ResponseApi<any> = Response200({ activeConnections });
    res.status(response.code).json(response);
};

export {createFavor, setupStatusSSE, monitorConnections, updateCourierStatus, acceptFavor, cancelFavor, rejectFavor};