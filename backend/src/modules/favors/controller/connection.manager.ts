// ConnectionManager.ts
import { Response } from 'express';
import EventEmitter from 'events';

interface Connection {
  connectionId: string;
  res: Response;
  intervalId: NodeJS.Timeout;
  fieldId: string;
}

class ConnectionManager extends EventEmitter {
  private static instance: ConnectionManager;
  private connections: Map<string, Connection>;
  private readonly MAX_CONNECTIONS = 10000;

  private constructor() {
    super();
    this.connections = new Map();
  }

  public static getInstance(): ConnectionManager {
    if (!ConnectionManager.instance) {
      ConnectionManager.instance = new ConnectionManager();
    }
    return ConnectionManager.instance;
  }

  public addConnection(connectionId: string, res: Response, intervalId: NodeJS.Timeout, fieldId: string): boolean {
    if (this.connections.size >= this.MAX_CONNECTIONS) {
      return false;
    }

    this.connections.set(connectionId, { connectionId, res, intervalId, fieldId });
    this.emit('connection-added', connectionId);
    return true;
  }

  public removeConnection(userId: string): void {
    const connection = this.connections.get(userId);
    if (connection) {
      clearInterval(connection.intervalId);
      connection.res.end();
      this.connections.delete(userId);
      this.emit('connection-removed', userId);
    }
  }

  public getConnection(userId: string): Connection | undefined {
    return this.connections.get(userId);
  }

  public getActiveConnections(): number {
    return this.connections.size;
  }

  public getConnectionsByFieldId(fieldId: string): Connection[] {
    return Array.from(this.connections.values()).filter(
      (connection) => connection.fieldId === fieldId
    );
  }
}

export const connectionManager = ConnectionManager.getInstance();