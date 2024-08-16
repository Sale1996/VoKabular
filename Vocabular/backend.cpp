#include "backend.h"
#include <QDebug>
#include <QDir>
#include <QCoreApplication>
#include <QRandomGenerator>
#include <algorithm>

Backend::Backend(QObject *parent)
    : QObject{parent}
{
    loadVocabularies();

    //connect timer
    connect(&m_timer, &QTimer::timeout, this, &Backend::timeout);
    m_timer.setInterval(1000); // interval
}

QString Backend::word()
{
    return m_word;
}

void Backend::setWord(QString newWord)
{
    m_word = newWord;

    emit wordChanged();
}

QString Backend::translatedWord()
{
    return m_exerciseVocabulary.value(m_word);
}

QList<QString> Backend::categories()
{
    return m_categories;
}

void Backend::chosenCategoriesUpdated(QVariant category, QVariant checked)
{
    //m_exerciseVocabulary.clear();
    if(checked.toBool())
    {
        m_exerciseVocabulary.insert(m_vocabularies.value(category.toString()));
    }
    else
    {
        QList<QString> keysToRemove = m_vocabularies.value(category.toString()).keys();

        for (const QString &key: keysToRemove)
        {
            m_exerciseVocabulary.remove(key);
        }
    }

    if(!m_exerciseVocabulary.empty())
            getNewWordPair();
    else
    {
        setWord("");
        emit categoriesListEmpty();
    }


    int a = 0;
}

void Backend::getNewWordPair()
{
    QList<QString> keys = m_exerciseVocabulary.keys();
    int randIndex = QRandomGenerator::global()->bounded(keys.size()-1);

    setWord(keys.at(randIndex));
    //m_word = keys.at(randIndex);
    int a = 0;
}

void Backend::startTest()
{
    m_correctAnswers.clear();
    m_wrongAnswers.clear();

    m_testActive = true;
    m_timer.start();
    m_testTime = 15;
    emit timerSecondPassed(m_testTime);
}

void Backend::cancelTest()
{
    m_correctAnswers.clear();
    m_wrongAnswers.clear();

    m_testActive = false;
    m_timer.stop();
}

void Backend::submitAnswer(QVariant answer)
{
    QString correctWord = translatedWord();

    if(translatedWord() == answer.toString())
    {
        m_correctAnswers.insert(m_word, correctWord);
        emit correctAnswer(answer);
    }
    else
    {
        m_wrongAnswers.insert(m_word, correctWord);
        emit wrongAnswer(answer);
    }
}

void Backend::getMatcherWords()
{
    QVariantList words;
    QVariantList translations;

    QList<QString> keys = m_exerciseVocabulary.keys();

    if(keys.length() < 5)
    {
        emit matcherWordsPrepared(words, translations);
        return;
    }

    //We need 6 words.
    for(int i = 0; i < 6; i++)
    {
        int randIndex = QRandomGenerator::global()->bounded(keys.size()-1);

        while(words.contains(keys.at(randIndex)))
        {
            randIndex = QRandomGenerator::global()->bounded(keys.size()-1);
        }

        words.append(keys.at(randIndex));
        translations.append(m_exerciseVocabulary[keys.at(randIndex)]);
    }

    //Finally suffle translations
    std::random_shuffle(translations.begin(), translations.end());

    emit matcherWordsPrepared(words, translations);
}

void Backend::submitMatch(QVariant firstWord, QVariant secondWord)
{
    if(m_exerciseVocabulary.contains(firstWord.toString()))
    {
        //case 1 firstWord == word, secondWord == translation
        QString correctMatch = m_exerciseVocabulary[firstWord.toString()];
        if(correctMatch == secondWord.toString())
            emit matchResult(true);
        else
            emit matchResult(false);
    }
    else if(m_exerciseVocabulary.contains(secondWord.toString()))
    {
        //case 2 firstWord == translation, secondWord == word
        QString correctMatch = m_exerciseVocabulary[secondWord.toString()];
        if(correctMatch == firstWord.toString())
            emit matchResult(true);
        else
            emit matchResult(false);
    }
    else
    {
        emit matchResult(false); //User clicked two translation buttons
    }
}

void Backend::timeout()
{
    m_testTime--;
    emit timerSecondPassed(m_testTime);

    if (m_testTime == 0)
    {
        m_timer.stop();
        emit testFinished(m_correctAnswers, m_wrongAnswers);
    }
}

QMap<QString, QString> Backend::read(QFile &file)
{
    QMap<QString, QString> categoryVocabulary;

    if(!file.isReadable())
    {
        qInfo() << "Unable to read to file!";
        return categoryVocabulary;
    }

    QTextStream stream(&file);
    stream.seek(0);

    while(!stream.atEnd())
    {
        QString line = stream.readLine();
        QStringList splittedLine = line.split(";");
        QString word = splittedLine[0];
        QString wordTranslated = splittedLine[1];
        categoryVocabulary.insert(word, wordTranslated);
    }

    return categoryVocabulary;
}

void Backend::loadVocabularies()
{
    //Go to the vocabulary directory
    QDir dir(QCoreApplication::applicationDirPath());
    dir.cd("vocabulary");

    foreach(QFileInfo fi, dir.entryInfoList(QDir::Filter::Files, QDir::Name))
    {
        if(fi.isFile())
        {
            QString filename = fi.fileName(); //QString filename = "text.txt";
            filename = filename.remove(".txt");
            m_categories.append(filename);

            QFile file(fi.absoluteFilePath());
            if(file.open(QIODevice::ReadOnly))
            {
                QTextStream stream(&file);
                QMap<QString, QString> fileVocabulary = read(file);
                m_vocabularies.insert(filename, fileVocabulary);

                file.close();
            }
            else
            {
                qInfo() << file.errorString();
            }
        }
    }
}

