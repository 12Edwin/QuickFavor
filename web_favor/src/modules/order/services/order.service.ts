import axios from "axios";
import * as api from "../../../config/http-client-gateway";
import {SSEOrderMessage, UpdateStateOrderEntity} from "@/modules/order/entity/order.entity";
import {getErrorMessages, ResponseEntity} from "@/kernel/error-response";
import axiosClientApi from "../../../config/http-client-gateway";
import Router from "@/router";
import {showErrorToast} from "@/kernel/alerts";
import {getErrorMessages as getErrors} from "@/kernel/utils";

export const getStreamAxios = async (ord: string, updateFunction: Function) => {
  const token = await localStorage.getItem('token');
  try {
    axios.get(`${api.getServerUrl()}/favor/status/${ord}`, {
      headers: {
        'Accept': 'text/event-stream',
        'Authorization': `Bearer ${token}`,
      },
      responseType: 'stream',
      adapter: 'fetch', // <- this option can also be set in axios.create()
    })
        .then(async (response) => {
          const stream: any = response.data;

          // consume response
          const reader = stream.pipeThrough(new TextDecoderStream()).getReader();
          while (true) {
            const {value, done} = await reader.read();
            if (done) break;
            try {
              const jsonData = await JSON.parse(value);
              const response = jsonData as SSEOrderMessage;
              await updateFunction(response);
            } catch (e) {
              console.log(`Error decodificando JSON:`, e);
            }
          }
        })
  } catch (error: any) {
    let resp = {} as ResponseEntity;
    if (error.response.data.data !== undefined && error.response.data.data !== null && Array.isArray(error.response.data.data)) {
      resp = getErrorMessages(error.response.data)
    }else {
      resp = error.response.data;
    }
    if (resp.error){
      showErrorToast(getErrors(resp.message));
      if (resp.code === 401){
        localStorage.removeItem('token');
        localStorage.removeItem('no_user');
        await Router.push({name: 'login'});
      }
    }
  }
}

export const getOrderDetails = async (order: string): Promise <ResponseEntity> => {
  try {
    const response = await axiosClientApi.doGet(`/favor/details/${order}`);
    return response.data;
  } catch (error: any) {
    if (error.response.data.data !== undefined && error.response.data.data !== null && Array.isArray(error.response.data.data)) {
      return getErrorMessages(error.response.data)
    }
    return error.response.data;
  }
}

export const updateOrderState = async (payload: UpdateStateOrderEntity): Promise <ResponseEntity> => {
  try {
    const response = await axiosClientApi.doPut(`/favor/status/${payload.no_order}`, payload);
    return response.data;
  } catch (error: any) {
    if (error.response.data.data !== undefined && error.response.data.data !== null && Array.isArray(error.response.data.data)) {
      return getErrorMessages(error.response.data)
    }
    return error.response.data;
  }
}

export const cancelOrder = async (payload: UpdateStateOrderEntity): Promise <ResponseEntity> => {
  try {
    const response = await axiosClientApi.doPut(`/favor/cancel/${payload.no_order}`, payload);
    return response.data;
  } catch (error: any) {
    if (error.response.data.data !== undefined && error.response.data.data !== null && Array.isArray(error.response.data.data)) {
      return getErrorMessages(error.response.data)
    }
    return error.response.data;
  }
}