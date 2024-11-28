import {AuthRepository} from "../repository/auth.repository";

const repository = new AuthRepository()
const toggleUserAccount = repository.toggleUserAccount
const existsUserByUid = repository.existsUserByUid
const existsCustomerById = repository.existsCustomerById
const existsCourierById = repository.existsCourierById
const existsUserByEmailWithDifferentUid = repository.existsUserByEmailWithDifferentUid
const existsUserByCurpWithDifferentUid = repository.existsUserByCurpWithDifferentUid
const existsUserByPhoneWithDifferentUid = repository.existsUserByPhoneWithDifferentUid


export {
    toggleUserAccount,
    existsUserByUid,
    existsCustomerById,
    existsCourierById,
    existsUserByEmailWithDifferentUid,
    existsUserByCurpWithDifferentUid,
    existsUserByPhoneWithDifferentUid
}