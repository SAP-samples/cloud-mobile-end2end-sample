package com.sap.mobile.mahlwerk.util

import com.sap.cloud.android.odata.odataservice.*
import com.sap.cloud.mobile.odata.DataQuery
import com.sap.mobile.mahlwerk.viewmodel.ViewModel

/**
 * Helper to stack materials and tools of the same type in order to avoid duplicates
 */
class MaterialOrganizer(private val viewModel: ViewModel) {
    /** The tools to stack */
    private val tools = mutableSetOf<Tool>()

    /** The materials to stack */
    private val materials = mutableMapOf<Material, Short>()

    /** The tools as a sorted list */
    val sortedTools: MutableList<Tool>
        get() = tools.sortedBy { it.name }.toMutableList()

    /** The materials as a sorted list */
    val sortedMaterials: MutableList<Pair<Material, Short>>
        get() = materials.toList().sortedBy { it.first.name }.toMutableList()

    /**
     * Stack tools and materials from a list of tasks
     *
     * @param tasks the task to get the tools and materials
     */
    fun addFromTasks(tasks: List<Task>) {
        tasks.forEach { addFromTask(it) }
    }

    /**
     * Stack tools and materials from a task
     *
     * @param task the task to get the tools and materials
     */
    fun addFromTask(task: Task) {
        viewModel.loadProperties(
            task,
            Task.job,
            query = DataQuery().expand(Job.materialPosition).expand(Job.toolPosition)
        )

        task.job.forEach { addFromJob(it) }
    }

    /**
     * Stack tools and materials from a job
     *
     * @param job the job to get the tools and materials
     */
    fun addFromJob(job: Job) {
        if (job.suggested) {
            return
        }

        viewModel.loadProperties(
            job,
            Job.toolPosition,
            query = DataQuery().expand(ToolPosition.tool)
        )

        viewModel.loadProperties(
            job,
            Job.materialPosition,
            query = DataQuery().expand(MaterialPosition.material)
        )

        job.materialPosition.forEach {
            val currentQuantity = materials[it.material] ?: 0
            materials[it.material] = currentQuantity.plus(it.quantity).toShort()
        }

        job.toolPosition.forEach {
            tools.add(it.tool)
        }
    }
}