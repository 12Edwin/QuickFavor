// modules/location/locationController.ts
import { Request, Response } from 'express';
import { LocationClient } from '../../../grpc/services/locationService';

const locationClient = new LocationClient('localhost:50051');

export class LocationController {
  async getLocation(req: Request, res: Response) {
    try {
      const { latitude, longitude } = req.query;

      const location = await locationClient.getLocation(
        Number(latitude),
        Number(longitude)
      );

      res.json(location);
    } catch (error: any) {
      res.status(500).json({
        error: 'Error getting location',
        details: error.message
      });
    }
  }
}