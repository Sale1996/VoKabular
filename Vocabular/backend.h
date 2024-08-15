#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QMap>
#include <QVariant>
#include <QTimer>

class Backend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString word READ word WRITE setWord  NOTIFY wordChanged)
    Q_PROPERTY(QString translatedWord READ translatedWord NOTIFY translatedWordChanged)
    Q_PROPERTY(QList<QString> categories READ categories NOTIFY categoriesChanged)

public:
    explicit Backend(QObject *parent = nullptr);

    QString word();
    void setWord(QString newWord);
    QString translatedWord();
    QList<QString> categories();


signals:
    void wordChanged();
    void translatedWordChanged();
    void categoriesChanged();
    void timerSecondPassed(QVariant data);
    void correctAnswer(QVariant userAnswer);
    void wrongAnswer(QVariant userAnswer);
    void testFinished(QVariantMap correctAnswers, QVariantMap wrongAnswers);
    void matcherWordsPrepared(QVariantList words, QVariantList translations);
    void matchResult(QVariant result);

public slots:
    void chosenCategoriesUpdated(QVariant category, QVariant checked);
    void getNewWordPair();
    void startTest();
    void cancelTest();
    void submitAnswer(QVariant answer);
    void getMatcherWords();
    void submitMatch(QVariant firstWord, QVariant secondWord);

private slots:
    void timeout();

private:
    QMap<QString, QString> read(QFile &file);
    void loadVocabularies();

private:
    QMap<QString, QMap<QString, QString>> m_vocabularies;
    QList<QString> m_categories;
    QMap<QString, QString> m_exerciseVocabulary;
    QString m_word;
    QTimer m_timer;
    int m_testTime = 30;
    bool m_testActive;
    QVariantMap m_correctAnswers;
    QVariantMap m_wrongAnswers;
};

#endif // BACKEND_H
