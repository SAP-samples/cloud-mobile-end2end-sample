package com.sap.mobile.mahlwerk.repository

import java.util.*

/*
 * Generic type to report CRUD operation result for entity type as type
 */
class OperationResult<T>(var operation: Operation) {
    /** List of entities for the entity type returned as a result of the operation */
    lateinit var result: MutableList<T>

    /** Exception encountered performing operation */
    var error: Exception? = null

    val singleResult: T?
        get() = result[0]

    /**
     * CRUD Operations
     */
    enum class Operation {
        CREATE,
        READ,
        UPDATE,
        DELETE
    }

    /**
     * Used by either UPDATE or CREATE  modified/created entity returned
     * @param result -  modified/created entity returned
     * @param op
     */
    constructor(result: T, op: Operation) : this(op) {
        this.result = ArrayList()
        this.result.add(result)
    }

    /**
     * Used by delete to confirm items in the list have been removed successfully
     * @param result - List of entities deleted
     * @param op
     */
    constructor(result: MutableList<T>, op: Operation) : this(op) {
        this.result = result
    }

    /**
     * Used to report an exception encountered during execution
     * @param error
     * @param op
     */
    constructor(error: Exception, op: Operation) : this(op) {
        this.error = error
    }
}