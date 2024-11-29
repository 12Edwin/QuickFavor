import axios from "axios";
import * as api from "../../../config/http-client-gateway";
import {SSEOrderMessage, UpdateStateOrderEntity} from "@/modules/order/entity/order.entity";
import {getErrorMessages, ResponseEntity} from "@/kernel/error-response";
import axiosClientApi from "../../../config/http-client-gateway";
import Router from "@/router";
import {showErrorToast} from "@/kernel/alerts";
import {getErrorMessages as getErrors} from "@/kernel/utils";
import {AcceptFavorEntity} from "@/modules/alert/entity/notification.entity";

export const getNotifications = async (courier_id: string): Promise <ResponseEntity> => {
  try {
    const response = await axiosClientApi.doGet(`/favor/notification/${courier_id}`);
    return response.data;
  } catch (error: any) {
    if (error.response.data.data !== undefined && error.response.data.data !== null && Array.isArray(error.response.data.data)) {
      return getErrorMessages(error.response.data)
    }
    return error.response.data;
  }
}

export const acceptFavor = async (payload: AcceptFavorEntity): Promise <ResponseEntity> => {
  try {
    const response = await axiosClientApi.doPut(`/favor/accept/${payload.order_id}`, payload);
    return response.data;
  } catch (error: any) {
    if (error.response.data.data !== undefined && error.response.data.data !== null && Array.isArray(error.response.data.data)) {
      return getErrorMessages(error.response.data)
    }
    return error.response.data;
  }
}

export const rejectFavor = async (payload: AcceptFavorEntity): Promise <ResponseEntity> => {
  try {
    const response = await axiosClientApi.doPut(`/favor/reject/${payload.order_id}`, payload);
    return response.data;
  } catch (error: any) {
    if (error.response.data.data !== undefined && error.response.data.data !== null && Array.isArray(error.response.data.data)) {
      return getErrorMessages(error.response.data)
    }
    return error.response.data;
  }
}