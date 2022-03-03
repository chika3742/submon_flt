package net.chikach.submon

import androidx.room.*

@Database(entities = [Submission::class], version = 1, exportSchema = false)
abstract class AppDatabase : RoomDatabase() {
    abstract fun submissionDao(): SubmissionDao
}

@Entity
data class Submission(
    @PrimaryKey val id: Int?,
    val date: String,
    val title: String,
    val done: Int,
    val detail: String,
    val important: Int,
    val color: Int,
    val repeat: Int,
)

@Dao
interface SubmissionDao {
    @Query("select * from submission where done = (0)")
    fun getAllUndone(): List<Submission>
}