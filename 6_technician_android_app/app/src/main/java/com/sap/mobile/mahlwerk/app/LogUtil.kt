package com.sap.mobile.mahlwerk.app

import android.content.res.Resources
import ch.qos.logback.classic.Level
import com.sap.mobile.mahlwerk.R

/**
 * Utility class to handle log level and string translation.
 */
class LogUtil(application: MahlwerkApplication) {

    private val res: Resources = application.resources

    /**
     * Array holding log level values.
     */
    val levelValues: Array<String> = arrayOf(
            Level.ALL.levelInt.toString(),
            Level.DEBUG.levelInt.toString(),
            Level.INFO.levelInt.toString(),
            Level.WARN.levelInt.toString(),
            Level.ERROR.levelInt.toString(),
            Level.OFF.levelInt.toString())

    /**
     * Array holding log level translated strings.
     */
    val levelStrings: Array<String> = arrayOf(
            res.getString(R.string.log_level_path),
            res.getString(R.string.log_level_debug),
            res.getString(R.string.log_level_info),
            res.getString(R.string.log_level_warning),
            res.getString(R.string.log_level_error),
            res.getString(R.string.log_level_none))

    /**
     * Get translated string for log level object
     *
     * @param level log level object
     * @return translated string for log level
     */
    fun getLevelString(level: Level?): String {
        level?.let {
            val index = levelValues.indexOf(it.levelInt.toString())
            return levelStrings[index]
        }

        return ""
    }

    /**
     * Get translated string for log level value
     *
     * @param levelValue log level value
     * @return translated string for log level value
     */
    fun getLevelString(levelValue: String?): String {
        levelValue?.let {
            val index = levelValues.indexOf(it)
            return levelStrings[index]
        }

        return ""
    }
}
