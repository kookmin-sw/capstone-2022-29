import React, {useEffect, useState} from 'react'
import {AvatarCell, StatusPill} from './Table'
import axios from "axios";
import NewsTable from "./newsTable";
import {Loading} from "./loading";  // new

const getData = async () => {
    const response = await axios({
        method: 'GET',
        url: `http://ec2-54-180-2-66.ap-northeast-2.compute.amazonaws.com:5000/news?page=1&perPage=10000`,
    });
    return response.data;
}


function News() {
    const [newsData, setNewsData] = useState();

    useEffect(() => {
        async function fetchRequest() {
            setNewsData(await getData())
        }
        fetchRequest();
    }, [])

    const columns = React.useMemo(() => [
        {
            Header: "title",
            accessor: 'title',
            Cell: AvatarCell,
            imgAccessor: null,
            emailAccessor: "url",
        },
        {
            Header: "journal",
            accessor: 'journal',
            Cell: StatusPill,
        },
        {
            Header: "date",
            accessor: 'date',
        },
        {
            Header: "summary",
            accessor: 'summary',
        },
    ], [])

    if (!newsData) {
        return <Loading/>
    } else {
        return <>
            <header className="bg-white shadow">
                <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
                    <h1 className="text-3xl font-bold text-gray-900">NEWS</h1>
                </div>
            </header>
            <div className="min-h-screen bg-gray-100 text-gray-900 pb-40">
                <main className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 pt-4">
                    <div className="mt-4">
                        <h1 className="text-3xl font-bold text-gray-900">모든 뉴스 목록</h1>
                        <p className="mb-10">최근 10,000개의 뉴스 목록입니다.</p>
                        <NewsTable list columns={columns} data={newsData}/>
                    </div>
                </main>
            </div>
        </>
    }
}

export default News;